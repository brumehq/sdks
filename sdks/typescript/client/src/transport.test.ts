import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import { TransportNegotiator } from './transport/negotiator';
import type { Transport, TransportOptions } from './transport/types';
import type { TransportKind } from './transport/types';

function spyOnCreate(
  negotiator: TransportNegotiator,
  impl: (kind: TransportKind) => Transport,
) {
  return vi
    .spyOn(
      negotiator as unknown as { create: (kind: TransportKind) => Transport },
      'create',
    )
    .mockImplementation(impl);
}

function makeOpts(overrides?: Partial<TransportOptions>): TransportOptions {
  return {
    url: 'http://localhost:8080',
    token: 'test-token',
    onMessage: (_msg) => {},
    onEvent: (_ev) => {},
    onStateChange: (_state) => {},
    ...overrides,
  };
}

class MockTransport implements Transport {
  readonly kind: TransportKind;
  private shouldFail: boolean;
  private failDelay: number;

  constructor(kind: TransportKind, shouldFail = false, failDelay = 10) {
    this.kind = kind;
    this.shouldFail = shouldFail;
    this.failDelay = failDelay;
  }

  open(opts: TransportOptions): void {
    if (this.shouldFail) {
      setTimeout(() => {
        opts.onStateChange('failed');
        opts.onEvent({ type: 'error', error: new Error(`${this.kind} failed`) });
      }, this.failDelay);
    } else {
      setTimeout(() => {
        opts.onStateChange('connected');
        opts.onEvent({ type: 'open' });
      }, this.failDelay);
    }
  }

  close(): void {}
  send(): void {}
  isConnected(): boolean {
    return false;
  }
}

describe('TransportNegotiator', () => {
  let storage: Map<string, string>;

  beforeEach(() => {
    storage = new Map();
    vi.stubGlobal('localStorage', {
      getItem: (key: string) => storage.get(key) ?? null,
      setItem: (key: string, value: string) => storage.set(key, value),
      removeItem: (key: string) => storage.delete(key),
    });
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('returns websocket transport when websocket connects', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind, kind !== 'websocket'));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('websocket');
    spy.mockRestore();
  });

  it('falls back to sse when websocket fails', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', class {});
    vi.stubGlobal('EventSource', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind, kind === 'websocket'));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('sse');
    spy.mockRestore();
  });

  it('falls back to longpoll when websocket and sse fail', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', class {});
    vi.stubGlobal('EventSource', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind, kind !== 'longpoll'));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('longpoll');
    spy.mockRestore();
  });

  it('forceTransport bypasses negotiation', async () => {
    const negotiator = new TransportNegotiator();
    negotiator.forceTransport('sse');
    vi.stubGlobal('EventSource', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('sse');
    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith('sse');
    spy.mockRestore();
  });

  it('caches the successful transport kind', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind));

    await negotiator.negotiate(makeOpts());
    expect(storage.get('brume:transport:preference')).toBe('websocket');
    spy.mockRestore();
  });

  it('uses cached preference on subsequent calls', async () => {
    storage.set('brume:transport:preference', 'sse');
    vi.stubGlobal('EventSource', class {});

    const negotiator = new TransportNegotiator();
    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('sse');
    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith('sse');
    spy.mockRestore();
  });

  it('throws when all transports fail', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', class {});
    vi.stubGlobal('EventSource', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind, true));

    await expect(negotiator.negotiate(makeOpts())).rejects.toThrow('All transports failed');
    spy.mockRestore();
  });

  it('skips websocket when WebSocket global is undefined', async () => {
    const negotiator = new TransportNegotiator();
    vi.stubGlobal('WebSocket', undefined);
    vi.stubGlobal('EventSource', class {});

    const spy = spyOnCreate(negotiator, (kind) => new MockTransport(kind));

    const transport = await negotiator.negotiate(makeOpts());
    expect(transport.kind).toBe('sse');
    expect(spy).toHaveBeenCalledWith('sse');
    spy.mockRestore();
  });
});

describe('transport fallback integration', () => {
  it('client uses websocket then messages flow through', async () => {
    let mockWs: MockWebSocket | null = null;

    class MockWebSocket {
      static OPEN = 1;
      readyState = 1;
      onopen: (() => void) | null = null;
      onclose: ((ev: { code: number; reason: string }) => void) | null = null;
      onmessage: ((ev: { data: string }) => void) | null = null;
      onerror: (() => void) | null = null;
      sentMessages: string[] = [];

      constructor(_url: string) {
        mockWs = this;
        queueMicrotask(() => this.onopen?.());
      }

      send(data: string) {
        this.sentMessages.push(data);
      }
      close() {
        this.readyState = 3;
        this.onclose?.({ code: 1000, reason: 'close' });
      }
    }

    vi.stubGlobal('WebSocket', MockWebSocket);

    const { createClient } = await import('./index');
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });

    await new Promise((r) => setTimeout(r, 50));
    await Promise.resolve();
    await Promise.resolve();

    const ch = client.channel<{ msg: { text: string } }>('room:1');
    const handler = vi.fn<(payload: { text: string }) => void>();
    ch.on('msg', handler);

    mockWs!.onmessage!({
      data: JSON.stringify({ event: 'msg', channel: 'room:1', payload: { text: 'hello' } }),
    });

    expect(handler).toHaveBeenCalledWith({ text: 'hello' });
    client.disconnect();
    vi.unstubAllGlobals();
  });
});
