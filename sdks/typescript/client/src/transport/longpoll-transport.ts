import type { ClientMessage, Message } from '@brume/protocol';

import type { Transport, TransportOptions } from './types';

// P2-9 (audit 2026-06-14): exponential backoff with jitter matching
// the WS and SSE transports' shape (500ms initial → 30s max). The
// prior code used a flat 1000ms, producing a thundering herd under
// sustained outage.
const BACKOFF_INITIAL_MS = 500;
const BACKOFF_MAX_MS = 30_000;

function isWireMessage(value: unknown): value is ClientMessage | Message {
  if (typeof value !== 'object' || value === null)
return false;
  const obj = value as Record<string, unknown>;
  return typeof obj.event === 'string';
}

export class LongPollTransport implements Transport {
  readonly kind = 'longpoll' as const;
  private opts: TransportOptions | null = null;
  private baseUrl = '';
  private token = '';
  private channel = '';
  private active = false;
  private polling = false;
  private closedByUs = false;
  private backoffAttempt = 0;

  open(opts: TransportOptions): void {
    this.opts = opts;
    this.closedByUs = false;
    this.baseUrl = opts.url.replace(/\/$/, '');
    this.token = opts.token;
    this.channel = '';
    this.active = true;
    opts.onStateChange('connecting');
    opts.onStateChange('connected');
  }

  setChannel(channel: string): void {
    if (channel === this.channel && this.polling) 
return;
    this.channel = channel;
    this.polling = false;
    this.startPollLoop();
  }

  private async startPollLoop(): Promise<void> {
    if (this.polling || !this.channel || !this.opts) 
return;
    this.polling = true;

    while (this.active && !this.closedByUs) {
      try {
        const url = `${this.baseUrl}/v1/poll/${encodeURIComponent(this.channel)}`;
        const res = await fetch(url, {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${this.token}`,
          },
          signal: AbortSignal.timeout(60_000),
        });

        if (!this.active || this.closedByUs) 
break;

        if (res.status === 200) {
          this.backoffAttempt = 0;
          this.opts.onStateChange('connected');
          this.opts.onEvent({ type: 'open' });
          let parsed: unknown;
          try {
            parsed = await res.json();
          } catch {
            continue;
          }
          if (isWireMessage(parsed)) {
            const msg: ClientMessage | Message = {
              event: parsed.event,
              channel: this.channel,
              payload: parsed.payload,
              ref: parsed.ref,
            };
            this.opts.onMessage(msg);
          }
        } else if (res.status === 204) {
          continue;
        } else {
          await this.sleep(this.computeBackoff());
        }
      } catch {
        if (!this.active || this.closedByUs)
break;
        this.opts.onStateChange('reconnecting');
        this.opts.onEvent({ type: 'error', error: new Error('Long-poll fetch error') });
        await this.sleep(this.computeBackoff());
      }
    }

    this.polling = false;

    if (this.active && !this.closedByUs && this.channel && this.opts) {
      await this.sleep(this.computeBackoff());
      if (this.active && !this.closedByUs) {
        this.startPollLoop();
      }
    }
  }

  /// Compute the next backoff delay with exponential growth + jitter,
  /// matching the WS and SSE transports' shape (500ms → 30s).
  /// P2-9 (audit 2026-06-14).
  private computeBackoff(): number {
    const base = Math.min(BACKOFF_INITIAL_MS * 2 ** this.backoffAttempt, BACKOFF_MAX_MS);
    const jitter = Math.random() * base;
    this.backoffAttempt++;
    return jitter;
  }

  restart(): void {
    if (this.polling) 
return;
    this.closedByUs = false;
    this.active = true;
    if (this.channel) {
      this.startPollLoop();
    }
  }

  close(): void {
    this.closedByUs = true;
    this.active = false;
    this.opts?.onStateChange('disconnected');
    this.opts?.onEvent({ type: 'close' });
  }

  send(msg: ClientMessage): void {
    const url = `${this.baseUrl}/v1/channels/${encodeURIComponent(msg.channel ?? '')}/publish`;
    // P2-17 (audit 2026-06-14): surface publish failures via onEvent.
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.token}`,
      },
      body: JSON.stringify(msg),
    }).then((res) => {
      if (!res.ok && this.opts) {
        this.opts.onEvent({ type: 'error', error: new Error(`Long-poll publish failed: ${res.status}`) });
      }
    }).catch((err) => {
      if (this.opts) {
        this.opts.onEvent({ type: 'error', error: new Error(`Long-poll publish network error: ${err}`) });
      }
    });
  }

  isConnected(): boolean {
    return this.active && !this.closedByUs;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
