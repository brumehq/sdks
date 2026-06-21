import { LongPollTransport } from './longpoll-transport';
import { SseTransport } from './sse-transport';
import type { Transport, TransportKind, TransportOptions } from './types';
import { WebSocketTransport } from './websocket-transport';

const STORAGE_KEY = 'brume:transport:preference';
const PROBE_TIMEOUT_MS = 5000;

export class TransportNegotiator {
  private forceKind: TransportKind | null = null;

  forceTransport(kind: TransportKind): void {
    this.forceKind = kind;
  }

  async negotiate(opts: TransportOptions): Promise<Transport> {
    if (this.forceKind) {
      return this.tryOne(this.forceKind, opts);
    }

    const cached = this.getCached();
    if (cached) {
      try {
        return await this.tryOne(cached, opts);
      } catch {
        this.clearCached();
      }
    }

    const order = this.detectOrder();
    for (const kind of order) {
      try {
        const transport = await this.tryOne(kind, opts);
        this.cache(kind);
        return transport;
      } catch {
        // try next
      }
    }

    throw new Error('All transports failed');
  }

  private tryOne(kind: TransportKind, opts: TransportOptions): Promise<Transport> {
    return new Promise((resolve, reject) => {
      const transport = this.create(kind);

      const timer = setTimeout(() => {
        transport.close();
        reject(new Error(`${kind} timed out after ${PROBE_TIMEOUT_MS}ms`));
      }, PROBE_TIMEOUT_MS);

      const wrappedOpts: TransportOptions = {
        ...opts,
        onStateChange: (state) => {
          if (state === 'connected') {
            clearTimeout(timer);
            resolve(transport);
          } else if (state === 'failed') {
            clearTimeout(timer);
            reject(new Error(`${kind} failed`));
          }
          opts.onStateChange(state);
        },
        onMessage: opts.onMessage,
        onEvent: opts.onEvent,
      };

      try {
        transport.open(wrappedOpts);
      } catch (err) {
        clearTimeout(timer);
        reject(err);
      }
    });
  }

  private create(kind: TransportKind): Transport {
    switch (kind) {
      case 'websocket':
        return new WebSocketTransport();
      case 'sse':
        return new SseTransport();
      case 'longpoll':
        return new LongPollTransport();
    }
  }

  private detectOrder(): TransportKind[] {
    const order: TransportKind[] = [];
    if (typeof WebSocket !== 'undefined') 
order.push('websocket');
    if (typeof EventSource !== 'undefined') 
order.push('sse');
    order.push('longpoll');
    return order;
  }

  private getCached(): TransportKind | null {
    try {
      const val = localStorage.getItem(STORAGE_KEY);
      if (val === 'websocket' || val === 'sse' || val === 'longpoll') 
return val;
    } catch {
      // localStorage unavailable
    }
    return null;
  }

  private cache(kind: TransportKind): void {
    try {
      localStorage.setItem(STORAGE_KEY, kind);
    } catch {
      // localStorage unavailable
    }
  }

  private clearCached(): void {
    try {
      localStorage.removeItem(STORAGE_KEY);
    } catch {
      // localStorage unavailable
    }
  }
}
