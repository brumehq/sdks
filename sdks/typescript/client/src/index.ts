import {
  ACK_TIMEOUT_MS,
  PING_INTERVAL_MS,
  RECONNECT_INITIAL_MS,
  RECONNECT_MAX_MS,
  SystemEvent,
} from '@brume/protocol';
import type { ClientMessage, Message } from '@brume/protocol';

import type { Transport, TransportKind, TransportState } from './transport';
import { TransportNegotiator } from './transport';

export type { AuthMode } from './transport/types';

export type BrumeEvent = string;
export type BrumeMessage<P = unknown> = Message<P>;

function generateRef(): string {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }
  return `${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

export interface BrumeOptions {
  url: string;
  token: () => Promise<string> | string;
  transport?: 'auto' | TransportKind;
  /**
   * How the WebSocket transport carries the JWT to the gateway.
   *  - `'subprotocol'` (default, recommended): token travels inside
   *    `Sec-WebSocket-Protocol: brume.v1, brume.token.<jwt>`.
   *  - `'query'`: legacy `?token=<jwt>` query path. Use only if
   *    talking to an older gateway that doesn't support subprotocols.
   * SSE and long-poll transports always use the query path because
   * their underlying browser APIs don't allow custom headers.
   */
  auth?: 'subprotocol' | 'query';
  maxReconnectAttempts?: number;
  ackTimeoutMs?: number;
  onConnectionStateChange?: (state: TransportState) => void;
}

type EventHandler<P = unknown> = (payload: P) => void;

interface InternalMessage {
  event: string;
  channel?: string;
  payload?: unknown;
  ref?: string;
}

export interface SendOptions {
  queue?: boolean;
}

/**
 * Maximum number of messages buffered in the client-level
 * `pendingQueue` while the transport is disconnected.
 *
 * Audit P1-6 (2026-06-14): the prior code pushed to `pendingQueue`
 * without bound, so a consumer calling `channel.send()` in a tight
 * loop while the transport was `'reconnecting'` could grow the queue
 * indefinitely and OOM the browser tab. This cap mirrors the
 * per-`Channel` `MAX_QUEUE_SIZE = 50` discipline: when full, the
 * oldest message is dropped (FIFO) to make room for the newest.
 * Dropping the oldest is the right policy here — under reconnect
 * pressure, the newest message is the most time-sensitive and the
 * oldest is the stalest.
 */
const MAX_PENDING_QUEUE = 256;

class Channel<Events extends Record<string, unknown>> {
  private handlers = new Map<string, Set<EventHandler<unknown>>>();
  private presenceHandlers = new Set<EventHandler<unknown>>();
  private ackHandlers = new Map<string, (ok: boolean) => void>();
  private joinPromise: { resolve: () => void; reject: (err: Error) => void } | null = null;
  private joined = false;
  private queuedMessages: InternalMessage[] = [];
  private static MAX_QUEUE_SIZE = 50;
  private _connected = false;
  private name: string;
  private sendRaw: (msg: InternalMessage) => boolean;
  private ackTimeoutMs: number;
  private lastPresence: Record<string, unknown> | undefined;

  constructor(name: string, sendRaw: (msg: InternalMessage) => boolean, ackTimeoutMs: number) {
    this.name = name;
    this.sendRaw = sendRaw;
    this.ackTimeoutMs = ackTimeoutMs;
  }

  on<E extends keyof Events & string>(event: E, handler: EventHandler<Events[E]>): void {
    if (!this.handlers.has(event)) {
      this.handlers.set(event, new Set());
    }
    this.handlers.get(event)!.add(handler as EventHandler<unknown>);
  }

  off<E extends keyof Events & string>(event: E, handler: EventHandler<Events[E]>): void {
    this.handlers.get(event)?.delete(handler as EventHandler<unknown>);
  }

  send<E extends keyof Events & string>(
    event: E,
    payload: Events[E],
    options?: SendOptions,
  ): Promise<void> {
    return new Promise((resolve, reject) => {
      const ref = generateRef();
      const timeout = setTimeout(() => {
        this.ackHandlers.delete(ref);
        reject(new Error('Ack timeout'));
      }, this.ackTimeoutMs);
      this.ackHandlers.set(ref, (ok) => {
        clearTimeout(timeout);
        if (ok) 
resolve();
        else reject(new Error('Message rejected'));
      });
      const msg: InternalMessage = {
        event,
        channel: this.name,
        payload: payload as unknown,
        ref,
      };
      if (options?.queue && !this.isConnected()) {
        if (this.queuedMessages.length >= Channel.MAX_QUEUE_SIZE) {
          this.queuedMessages.shift();
        }
        this.queuedMessages.push(msg);
        clearTimeout(timeout);
        this.ackHandlers.delete(ref);
        resolve();
        return;
      }
      const ackExpected = this.sendRaw(msg);
      if (!ackExpected) {
        clearTimeout(timeout);
        this.ackHandlers.delete(ref);
        resolve();
        return;
      }
    });
  }

  track(state: Record<string, unknown>): void {
    this.lastPresence = state;
    this.sendRaw({
      event: SystemEvent.PresenceUpdate,
      channel: this.name,
      payload: state,
    });
  }

  join(presence?: Record<string, unknown>): Promise<void> {
    if (this.joined) 
return Promise.resolve();
    if (this.joinPromise) {
      return new Promise((res, rej) => {
        const existing = this.joinPromise!;
        const origResolve = existing.resolve;
        const origReject = existing.reject;
        existing.resolve = () => {
          origResolve();
          res();
        };
        existing.reject = (err: Error) => {
          origReject(err);
          rej(err);
        };
      });
    }

    if (presence) 
this.lastPresence = presence;

    return new Promise((resolve, reject) => {
      const ref = generateRef();
      const timeout = setTimeout(() => {
        this.joinPromise = null;
        this.ackHandlers.delete(ref);
        reject(new Error('Join timeout'));
      }, this.ackTimeoutMs);

      this.joinPromise = { resolve, reject };

      this.ackHandlers.set(ref, (ok) => {
        clearTimeout(timeout);
        this.joinPromise = null;
        if (ok) {
          this.joined = true;
          resolve();
        } else {
          reject(new Error('Join rejected'));
        }
      });

      const ackExpected = this.sendRaw({
        event: SystemEvent.Join,
        channel: this.name,
        payload: presence,
        ref,
      });
      if (!ackExpected) {
        clearTimeout(timeout);
        this.joinPromise = null;
        this.joined = true;
        resolve();
      }
    });
  }

  leave(): void {
    if (!this.joined) 
return;
    this.joined = false;
    this.sendRaw({
      event: SystemEvent.Leave,
      channel: this.name,
    });
  }

  /** @internal */
  dispatch(event: string, payload: unknown): void {
    if (event === SystemEvent.Presence) {
      for (const h of this.presenceHandlers) {
        try {
          h(payload);
        } catch (e) {
          console.error('Presence handler error:', e);
        }
      }
      return;
    }
    if (event === SystemEvent.Ack) {
      const ack = payload as { ref?: string };
      if (ack.ref && this.ackHandlers.has(ack.ref)) {
        const cb = this.ackHandlers.get(ack.ref)!;
        this.ackHandlers.delete(ack.ref);
        cb(true);
      }
      return;
    }
    const set = this.handlers.get(event);
    if (!set) 
return;
    for (const h of set) {
      try {
        h(payload);
      } catch (e) {
        console.error('Event handler error:', e);
      }
    }
  }

  /** @internal */
  onPresence(handler: EventHandler<unknown>): () => void {
    this.presenceHandlers.add(handler);
    return () => this.presenceHandlers.delete(handler);
  }

  /** @internal */
  getState() {
    return this.joined;
  }

  /** @internal */
  getLastPresence(): Record<string, unknown> | undefined {
    return this.lastPresence;
  }

  /** @internal */
  isConnected(): boolean {
    return this._connected;
  }

  /** @internal */
  markConnected(connected: boolean) {
    this._connected = connected;
  }

  /** @internal */
  flushQueue() {
    while (this.queuedMessages.length > 0) {
      const msg = this.queuedMessages.shift()!;
      this.sendRaw(msg);
    }
  }
}

class BrumeClientImpl {
  private transport: Transport | null = null;
  private channels = new Map<string, Channel<Record<string, unknown>>>();
  private reconnectTimer: ReturnType<typeof setTimeout> | null = null;
  private reconnectAttempt = 0;
  private maxReconnectAttempts: number;
  private pendingQueue: InternalMessage[] = [];
  private connected = false;
  private disposed = false;
  private pingInterval: ReturnType<typeof setInterval> | null = null;
  private pongTimeout: ReturnType<typeof setTimeout> | null = null;
  private ackTimeoutMs: number;
  private url: string;
  private tokenFn: () => Promise<string> | string;
  private negotiator: TransportNegotiator;

  constructor(private options: BrumeOptions) {
    this.url = options.url.replace(/\/$/, '');
    this.tokenFn = options.token;
    this.maxReconnectAttempts = options.maxReconnectAttempts ?? Infinity;
    this.ackTimeoutMs = options.ackTimeoutMs ?? ACK_TIMEOUT_MS;
    this.negotiator = new TransportNegotiator();

    if (options.transport && options.transport !== 'auto') {
      this.negotiator.forceTransport(options.transport);
    }

    this.connect();
  }

  private async connect() {
    if (this.disposed)
return;
    this.options.onConnectionStateChange?.('connecting');

    // P2-8 (audit 2026-06-14): surface token() rejection to the
    // consumer instead of swallowing it. The prior code left
    // tokenFn() outside the try/catch, so a rejecting token function
    // became an unhandled promise rejection; and the negotiate catch
    // discarded the error reason entirely. Now both paths emit the
    // error via onConnectionStateChange('failed') and schedule a
    // reconnect, with the error logged to the console for debug.
    let token: string;
    try {
      token = typeof this.tokenFn === 'function' ? await this.tokenFn() : this.tokenFn;
    } catch (err) {
      console.error('Brume: token() rejected:', err);
      this.options.onConnectionStateChange?.('failed');
      this.handleStateChange('reconnecting');
      return;
    }

    try {
      this.transport = await this.negotiator.negotiate({
        url: this.url,
        token,
        auth: this.options.auth,
        onMessage: (msg) => this.handleMessage(msg),
        onEvent: (_ev) => {},
        onStateChange: (state) => this.handleStateChange(state),
      });
    } catch (err) {
      console.error('Brume: transport negotiation failed:', err);
      this.options.onConnectionStateChange?.('failed');
      this.handleStateChange('reconnecting');
    }
  }

  private handleStateChange(state: TransportState) {
    switch (state) {
      case 'connected':
        this.connected = true;
        this.reconnectAttempt = 0;
        this.options.onConnectionStateChange?.('connected');
        this.flushPending();
        this.startPing();
        // Re-join channels after reconnect
        for (const [name, ch] of this.channels) {
          ch.markConnected(true);
          if (ch.getState()) {
            const presence = ch.getLastPresence();
            this.sendRaw({
              event: SystemEvent.Join,
              channel: name,
              ...(presence ? { payload: presence } : {}),
            });
          }
          ch.flushQueue();
        }
        break;

      case 'reconnecting':
        this.connected = false;
        this.stopPing();
        for (const [, ch] of this.channels) {
          ch.markConnected(false);
        }
        this.options.onConnectionStateChange?.('reconnecting');
        this.scheduleReconnect();
        break;

      case 'disconnected':
        this.connected = false;
        this.stopPing();
        for (const [, ch] of this.channels) {
          ch.markConnected(false);
        }
        this.options.onConnectionStateChange?.('disconnected');
        break;

      case 'failed':
        this.connected = false;
        this.stopPing();
        for (const [, ch] of this.channels) {
          ch.markConnected(false);
        }
        this.options.onConnectionStateChange?.('failed');
        break;
    }
  }

  private handleMessage(msg: ClientMessage) {
    // Audit P1-7 (2026-06-14): clear the pong-timeout watchdog when
    // a Pong arrives so a slow-but-alive connection doesn't get
    // killed. The watchdog was previously a no-op; now it both
    // clears on success AND fires a reconnect on miss.
    if (msg.event === SystemEvent.Pong) {
      if (this.pongTimeout) {
        clearTimeout(this.pongTimeout);
        this.pongTimeout = null;
      }
      return;
    }
    if (!msg.channel) return;
    const ch = this.channels.get(msg.channel);
    if (ch) ch.dispatch(msg.event, msg.payload ?? {});
  }

  private scheduleReconnect() {
    if (this.disposed) 
return;
    if (this.reconnectAttempt >= this.maxReconnectAttempts) {
      console.error('Brume: max reconnect attempts reached');
      this.options.onConnectionStateChange?.('failed');
      return;
    }
    const base = Math.min(RECONNECT_INITIAL_MS * 2 ** this.reconnectAttempt, RECONNECT_MAX_MS);
    const jitter = Math.random() * base;
    this.reconnectAttempt++;
    this.reconnectTimer = setTimeout(() => {
      // Audit Disputed-1 (2026-06-14): the prior code did `return` for
      // SSE here, leaving the consumer stuck in `'failed'` state when
      // the SSE transport's own reconnect signaled terminal failure.
      // Every transport gets a fresh connect() attempt: SSE and
      // long-poll re-run negotiation (cheap), WS re-opens the socket.
      if (this.transport?.kind === 'longpoll') {
        // Long-poll has a `restart()` that re-issues the same poll
        // request with the existing token. Cheaper than a full
        // negotiate; preferred when the transport is healthy.
        this.transport.restart?.();
        return;
      }
      this.connect();
    }, jitter);
  }

  private sendRaw(msg: InternalMessage): boolean {
    const passiveTransport = this.transport?.kind === 'sse' || this.transport?.kind === 'longpoll';
    if (passiveTransport) {
      if (msg.event === SystemEvent.Join && msg.channel) {
        this.transport?.setChannel?.(msg.channel);
      }
      if (
        msg.event === SystemEvent.Join ||
        msg.event === SystemEvent.Leave ||
        msg.event === SystemEvent.PresenceUpdate ||
        msg.event === SystemEvent.Ping
      ) {
        return false;
      }
    }

    if (!this.connected || !this.transport) {
      // Audit P1-6 (2026-06-14): bound the client-level pending
      // queue. The per-Channel `queuedMessages` array is already
      // capped at `MAX_QUEUE_SIZE = 50`; this client-level queue was
      // unbounded, risking OOM under a reconnect storm. When full,
      // drop the oldest (FIFO) — under reconnect pressure the newest
      // message is the most time-sensitive.
      if (this.pendingQueue.length >= MAX_PENDING_QUEUE) {
        this.pendingQueue.shift();
      }
      this.pendingQueue.push(msg);
      return true;
    }

    if (msg.event === SystemEvent.Join && msg.channel && this.transport.setChannel) {
      this.transport.setChannel(msg.channel);
    }

    this.transport.send(msg);
    return true;
  }

  private flushPending() {
    while (this.pendingQueue.length > 0) {
      const msg = this.pendingQueue.shift()!;
      this.sendRaw(msg);
    }
  }

  private startPing() {
    this.stopPing();
    this.pingInterval = setInterval(() => {
      this.sendRaw({ event: SystemEvent.Ping });
      this.pongTimeout = setTimeout(() => {
        // Audit P1-7 (2026-06-14): prior code had a no-op body here,
        // so a hung TCP socket (proxy in the middle, server stuck) was
        // never detected by the SDK. Now: force-close the transport
        // and trigger a reconnect, so the consumer eventually sees
        // state `'reconnecting'` and recovers when the network
        // returns.
        const transport = this.transport;
        if (transport && this.handleStateChange) {
          this.handleStateChange('reconnecting');
        }
        try {
          transport?.close();
        } catch {
          // close() can throw if the underlying socket is already
          // gone; swallow and let connect() rebuild from scratch.
        }
      }, PING_INTERVAL_MS);
    }, PING_INTERVAL_MS);
  }

  private stopPing() {
    if (this.pingInterval) {
      clearInterval(this.pingInterval);
      this.pingInterval = null;
    }
    if (this.pongTimeout) {
      clearTimeout(this.pongTimeout);
      this.pongTimeout = null;
    }
  }

  channel<Events extends Record<string, unknown> = Record<string, unknown>>(
    name: string,
  ): TypedChannel<Events> {
    if (!this.channels.has(name)) {
      const ch = new Channel(name, this.sendRaw.bind(this), this.ackTimeoutMs);
      ch.markConnected(this.connected);
      this.channels.set(name, ch as unknown as Channel<Record<string, unknown>>);
    }
    return this.channels.get(name)! as unknown as TypedChannel<Events>;
  }

  disconnect() {
    this.disposed = true;
    if (this.reconnectTimer) 
clearTimeout(this.reconnectTimer);
    this.stopPing();
    this.transport?.close();
    this.options.onConnectionStateChange?.('disconnected');
  }
}

export interface TypedChannel<Events extends Record<string, unknown>> {
  on<E extends keyof Events & string>(event: E, handler: EventHandler<Events[E]>): void;
  off<E extends keyof Events & string>(event: E, handler: EventHandler<Events[E]>): void;
  send<E extends keyof Events & string>(
    event: E,
    payload: Events[E],
    options?: SendOptions,
  ): Promise<void>;
  track(state: Record<string, unknown>): void;
  join(presence?: Record<string, unknown>): Promise<void>;
  leave(): void;
  onPresence(handler: EventHandler<unknown>): () => void;
}

export interface BrumeClient {
  channel<Events extends Record<string, unknown> = Record<string, unknown>>(
    name: string,
  ): TypedChannel<Events>;
  disconnect(): void;
}

export function createClient(options: BrumeOptions): BrumeClient {
  return new BrumeClientImpl(options);
}

export {
  LongPollTransport,
  SseTransport,
  type Transport,
  TransportNegotiator,
  type TransportEvent,
  type TransportKind,
  type TransportOptions,
  type TransportState,
  WebSocketTransport,
} from './transport';

export {
  type AckPayload,
  type BrumeError,
  type ClientMessage,
  ClientSystemEvent,
  type ClientSystemEvent as ClientSystemEventType,
  type ConnectedPayload,
  ErrorCode,
  type ErrorCode as ErrorCodeType,
  isClientSystemEvent,
  isSystemEvent,
  MAX_PAYLOAD_SIZE,
  type Message,
  type PresenceUpdatePayload,
  type PresenceUser,
  ServerSystemEvent,
  type ServerSystemEvent as ServerSystemEventType,
  SystemEvent,
  type SystemEvent as SystemEventType,
  validateChannelName,
} from '@brume/protocol';

export {
  formatPlanLimit,
  isPlanLimit,
  type FormattedPlanLimit,
  type PlanLimitPayload,
  type PlanLimitReason,
  type UpgradeTier,
} from './error-helpers';
