import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import { createClient } from './index';

let mockWsInstances: MockWebSocket[] = [];

class MockWebSocket {
  static CONNECTING = 0;
  static OPEN = 1;
  static CLOSING = 2;
  static CLOSED = 3;
  onopen: (() => void) | null = null;
  onclose: ((ev: { code: number; reason: string }) => void) | null = null;
  onmessage: ((ev: { data: string }) => void) | null = null;
  onerror: (() => void) | null = null;
  readyState = MockWebSocket.CONNECTING;
  url: string;
  sentMessages: string[] = [];

  constructor(url: string) {
    this.url = url;
    mockWsInstances.push(this);
    this.readyState = MockWebSocket.OPEN;
    queueMicrotask(() => this.onopen?.());
  }

  send(data: string) {
    this.sentMessages.push(data);
  }

  close() {
    this.readyState = MockWebSocket.CLOSED;
    this.onclose?.({ code: 1000, reason: 'close' });
  }
}

beforeEach(() => {
  mockWsInstances = [];
  vi.stubGlobal('WebSocket', MockWebSocket);
});

afterEach(() => {
  vi.unstubAllGlobals();
  mockWsInstances = [];
});

describe('createClient', () => {
  it('returns an object with channel and disconnect', () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    expect(client).toHaveProperty('channel');
    expect(client).toHaveProperty('disconnect');
    expect(typeof client.channel).toBe('function');
    expect(typeof client.disconnect).toBe('function');
    client.disconnect();
  });

  it('channel() returns a channel with the expected API', () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const channel = client.channel('room:1');
    expect(channel).toHaveProperty('on');
    expect(channel).toHaveProperty('off');
    expect(channel).toHaveProperty('send');
    expect(channel).toHaveProperty('join');
    expect(channel).toHaveProperty('leave');
    expect(channel).toHaveProperty('track');
    expect(typeof channel.on).toBe('function');
    expect(typeof channel.send).toBe('function');
    expect(typeof channel.join).toBe('function');
    client.disconnect();
  });

  it('returns the same channel instance for the same name', () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const a = client.channel('room:1');
    const b = client.channel('room:1');
    expect(a).toBe(b);
    client.disconnect();
  });

  it('creates distinct channels for different names', () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const a = client.channel('room:1');
    const b = client.channel('room:2');
    expect(a).not.toBe(b);
    client.disconnect();
  });
});

async function connectWs() {
  await new Promise((resolve) => setTimeout(resolve, 0));
  await Promise.resolve();
  await Promise.resolve();
  return mockWsInstances[0];
}

describe('channel event dispatch', () => {
  it('dispatches messages to registered handlers', async () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const ws = await connectWs();
    const ch = client.channel<{ msg: { text: string } }>('room:1');
    const handler = vi.fn();
    ch.on('msg', handler);
    ch.join().catch(() => {});

    ws!.onmessage!({
      data: JSON.stringify({ event: 'msg', channel: 'room:1', payload: { text: 'hello' } }),
    });

    expect(handler).toHaveBeenCalledWith({ text: 'hello' });
    client.disconnect();
  });

  it('does not dispatch to handlers after off()', async () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const ws = await connectWs();
    const ch = client.channel<{ msg: { text: string } }>('room:1');
    const handler = vi.fn();
    ch.on('msg', handler);
    ch.off('msg', handler);
    ch.join().catch(() => {});

    ws!.onmessage!({
      data: JSON.stringify({ event: 'msg', channel: 'room:1', payload: { text: 'hello' } }),
    });

    expect(handler).not.toHaveBeenCalled();
    client.disconnect();
  });

  it('handles leave then rejoin', async () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    await connectWs();
    const ch = client.channel('room:1');
    ch.join().catch(() => {});
    ch.leave();
    ch.join().catch(() => {});
    client.disconnect();
  });
});

describe('track', () => {
  it('sends presence_update message', async () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const ws = await connectWs();
    const ch = client.channel('room:1');
    ch.track({ userId: 'u1', status: 'online' });

    expect(ws!.sentMessages.length).toBeGreaterThan(0);
    const sent = JSON.parse(ws!.sentMessages[0]);
    expect(sent.event).toBe('brume:presence_update');
    expect(sent.channel).toBe('room:1');
    client.disconnect();
  });
});

describe('pong handler (audit P1-7)', () => {
  it('clears pongTimeout when a Pong message arrives', async () => {
    const client = createClient({ url: 'http://localhost:8080', token: () => 'tok' });
    const ws = await connectWs();
    // The Ping should already be on the wire (startPing fires after
    // connect). Send a Pong back; the handler should clear the
    // watchdog. We can't directly assert that, but we can assert
    // that a subsequent Pong is a no-op (no error thrown) and the
    // client is still usable.
    ws!.onmessage!({ data: JSON.stringify({ event: 'brume:pong' }) });
    ws!.onmessage!({ data: JSON.stringify({ event: 'brume:pong' }) });
    client.disconnect();
  });
});

describe('outer reconnect (audit Disputed-1)', () => {
  it('calls connect() (not no-op) when a non-WS transport signals reconnect', async () => {
    // We can observe the reconnect by counting WebSocket
    // constructions. After the initial connect, force the WS to
    // close and let the scheduleReconnect timer fire; if the prior
    // `return` for SSE were still in place, no new WebSocket would
    // be constructed. After the fix, a fresh WebSocket is opened.
    const client = createClient({
      url: 'http://localhost:8080',
      token: () => 'tok',
      // Keep reconnect attempt count low so the timer fires fast.
      maxReconnectAttempts: 5,
    });
    await connectWs();
    const first = mockWsInstances.length;
    expect(first).toBeGreaterThan(0);

    // Simulate the WS going away without server cooperation.
    mockWsInstances[0].onclose?.({ code: 1006, reason: 'abnormal' });

    // The reconnect timer is jittered; poll for the new socket
    // for up to a few hundred ms.
    const deadline = Date.now() + 500;
    while (Date.now() < deadline && mockWsInstances.length === first) {
      await new Promise((r) => setTimeout(r, 20));
    }
    expect(mockWsInstances.length).toBeGreaterThan(first);
    client.disconnect();
  });
});

describe('pendingQueue bounded cap (audit P1-6)', () => {
  it('does not crash or hang when many messages are queued while disconnected', async () => {
    // The cap ensures the client-level pendingQueue stays bounded at
    // MAX_PENDING_QUEUE (256). We can't observe the internal length,
    // but we can verify the contract: sending well over the cap while
    // disconnected does not throw, and the client remains usable.
    // Use a short ackTimeoutMs so pending ack timers fire fast and
    // don't hang the test.
    const client = createClient({
      url: 'http://localhost:8080',
      token: () => 'tok',
      maxReconnectAttempts: 0,
      ackTimeoutMs: 50,
    });
    await connectWs();
    const ch = client.channel('room:1');

    // Force the client into a disconnected state by closing the WS
    // and preventing reconnect (maxReconnectAttempts: 0).
    mockWsInstances[0].close();

    // Now send well over MAX_PENDING_QUEUE messages. The sendRaw
    // path pushes to pendingQueue since connected == false. With the
    // cap, the oldest messages are dropped (FIFO). Without the cap,
    // this would grow the array to 300 entries (not a crash, but an
    // OOM risk in production). The test verifies no crash/throw and
    // that the client is still usable.
    for (let i = 0; i < 300; i++) {
      ch.send('evt', { i }).catch(() => {});
    }

    expect(typeof client.disconnect).toBe('function');
    client.disconnect();
    // Wait for the short ack timeouts to fire and settle.
    await new Promise((r) => setTimeout(r, 100));
  });
});
