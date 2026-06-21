import type { ClientMessage, Message } from '@brume/protocol';

import type { Transport, TransportOptions } from './types';

function isWireMessage(value: unknown): value is ClientMessage | Message {
  if (typeof value !== 'object' || value === null) return false;
  const obj = value as Record<string, unknown>;
  return typeof obj.event === 'string';
}

// EventSource has built-in auto-reconnect, but it does so silently
// without telling the consumer. The Brume consumer expects explicit
// 'reconnecting' state changes so the UI can show a "reconnecting…"
// banner. We therefore close and re-open ourselves on error and
// own the reconnect loop here.
const RECONNECT_INITIAL_MS = 500;
const RECONNECT_MAX_MS = 30_000;

export class SseTransport implements Transport {
  readonly kind = 'sse' as const;
  private eventSource: EventSource | null = null;
  private opts: TransportOptions | null = null;
  private baseUrl = '';
  private token = '';
  private channel = '';
  private closedByUs = false;
  // The actual EventSource only opens when `setChannel()` is called
  // by the consumer. We track whether `open()` has been called so we
  // can defer the initial 'connecting' state until then.
  private hasOpened = false;
  // Whether the current EventSource has ever received `onopen`.
  // Used to distinguish initial-open-failure (4xx, no network) from
  // mid-stream-disconnect (the connection was up and then died).
  // EventSource's `onerror` fires for both cases with no way to tell
  // them apart, so we track the open ourselves.
  private everOpened = false;
  // Reconnect bookkeeping. `reconnectTimer` is the pending setTimeout
  // handle; `reconnectAttempt` is the exponential-backoff counter.
  private reconnectTimer: ReturnType<typeof setTimeout> | null = null;
  private reconnectAttempt = 0;

  open(opts: TransportOptions): void {
    this.opts = opts;
    this.closedByUs = false;
    this.hasOpened = true;
    this.baseUrl = opts.url.replace(/\/$/, '');
    this.token = opts.token;
    this.channel = '';
    // Do NOT fire 'connected' here. The actual EventSource only
    // opens when `setChannel()` is called by the consumer, and
    // 'connected' must be reported from `es.onopen` to keep the
    // state machine honest. (Previously this fired synchronously,
    // which lied to the consumer about being connected before any
    // stream had been opened.)
    this.reconnectAttempt = 0;
  }

  setChannel(channel: string): void {
    if (!this.hasOpened || !this.opts) return;
    if (channel === this.channel && this.eventSource) return;
    this.closeStream();
    this.cancelReconnect();
    this.channel = channel;
    this.openStream();
  }

  private openStream(): void {
    if (!this.channel || !this.opts) return;
    if (this.closedByUs) return;

    const sseUrl = `${this.baseUrl}/v1/sse/${encodeURIComponent(this.channel)}?token=${encodeURIComponent(this.token)}`;

    this.opts.onStateChange('connecting');

    let es: EventSource;
    try {
      es = new EventSource(sseUrl);
    } catch {
      // EventSource constructor only throws on invalid URL or when
      // EventSource is not supported. In either case the stream is
      // never going to open — fail the transport rather than
      // spinning a reconnect loop forever.
      this.opts.onStateChange('failed');
      this.opts.onEvent({ type: 'error', error: new Error('EventSource constructor threw') });
      return;
    }
    this.eventSource = es;
    this.everOpened = false;

    // The very first `onopen` is the source of truth for "connected".
    // Subsequent reconnects also flow through this handler, so the
    // existing 'connected' transition doubles as a "reconnected"
    // signal.
    es.onopen = () => {
      if (this.closedByUs) return;
      this.everOpened = true;
      this.reconnectAttempt = 0;
      this.opts!.onStateChange('connected');
      this.opts!.onEvent({ type: 'open' });
    };

    es.addEventListener('message', (ev: MessageEvent) => {
      if (this.closedByUs || !this.opts) return;
      let data: unknown;
      try {
        data = JSON.parse(ev.data);
      } catch {
        return;
      }
      if (!isWireMessage(data)) return;
      const msg: ClientMessage | Message = {
        event: data.event,
        channel: this.channel,
        payload: data.payload,
        ref: data.ref,
      };
      this.opts.onMessage(msg);
    });

    // EventSource.onerror fires in two distinct situations and the
    // API gives no way to tell them apart:
    //
    //  1. The stream was never opened (e.g. 4xx auth, no network at
    //     connect time). `es.readyState === CLOSED`. The browser
    //     will not auto-reconnect, and there is no point looping —
    //     the next attempt hits the same wall. Report a one-shot
    //     failure and let the consumer decide what to do.
    //
    //  2. The stream was up and was then disconnected (server kill,
    //     network blip). `es.readyState === CLOSED` here too, but
    //     the browser would normally auto-reconnect. We close + reopen
    //     ourselves so we control the backoff and emit 'reconnecting'.
    //
    // We distinguish via `this.everOpened`, which is set by `onopen`.
    es.onerror = () => {
      if (this.closedByUs || !this.opts) return;
      if (!this.everOpened) {
        // First-connect failure: the server rejected the upgrade or
        // the network is down at connect time. Don't loop — the
        // consumer will surface this and (in the case of the Brume
        // client) reconnect with a fresh token via its outer
        // reconnect loop.
        this.opts.onStateChange('failed');
        this.opts.onEvent({
          type: 'error',
          error: new Error('SSE connection error: initial open failed'),
        });
        this.eventSource?.close();
        this.eventSource = null;
        return;
      }
      // Mid-stream disconnect: back off and try to re-open.
      this.opts.onStateChange('reconnecting');
      this.opts.onEvent({ type: 'error', error: new Error('SSE connection error') });
      this.scheduleReconnect();
    };
  }

  private scheduleReconnect(): void {
    if (this.closedByUs) return;
    if (this.reconnectTimer) return;
    const base = Math.min(
      RECONNECT_INITIAL_MS * 2 ** this.reconnectAttempt,
      RECONNECT_MAX_MS,
    );
    const jitter = Math.random() * base;
    this.reconnectAttempt++;
    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null;
      if (this.closedByUs) return;
      this.eventSource?.close();
      this.eventSource = null;
      this.everOpened = false;
      this.openStream();
    }, jitter);
  }

  private cancelReconnect(): void {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
  }

  private closeStream(): void {
    this.cancelReconnect();
    this.eventSource?.close();
    this.eventSource = null;
    this.everOpened = false;
  }

  close(): void {
    this.closedByUs = true;
    this.closeStream();
    this.opts?.onStateChange('disconnected');
    this.opts?.onEvent({ type: 'close' });
  }

  send(msg: ClientMessage): void {
    const url = `${this.baseUrl}/v1/channels/${encodeURIComponent(msg.channel ?? '')}/publish`;
    // P2-17 (audit 2026-06-14): surface publish failures via onEvent
    // instead of swallowing them. The consumer can match on
    // event.type === 'error' to show a "publish failed" indicator.
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.token}`,
      },
      body: JSON.stringify({
        event: msg.event,
        channel: msg.channel,
        payload: msg.payload,
        ref: msg.ref,
      }),
    }).then((res) => {
      if (!res.ok && this.opts) {
        this.opts.onEvent({ type: 'error', error: new Error(`SSE publish failed: ${res.status}`) });
      }
    }).catch((err) => {
      if (this.opts) {
        this.opts.onEvent({ type: 'error', error: new Error(`SSE publish network error: ${err}`) });
      }
    });
  }

  isConnected(): boolean {
    return this.eventSource?.readyState === EventSource.OPEN;
  }
}
