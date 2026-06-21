import { describe, expect, it } from 'vitest';

import { createMockBrume } from './index';

describe('createMockBrume', () => {
  it('returns an object with a url and connect/simulate/destroy methods', () => {
    const mock = createMockBrume();
    expect(mock.url).toBeDefined();
    expect(typeof mock.connect).toBe('function');
    expect(typeof mock.simulateMessage).toBe('function');
    expect(typeof mock.simulateSystemEvent).toBe('function');
    expect(typeof mock.simulatePresenceJoin).toBe('function');
    expect(typeof mock.simulatePresenceLeave).toBe('function');
    expect(typeof mock.simulateAck).toBe('function');
    expect(typeof mock.getSentMessages).toBe('function');
    expect(typeof mock.destroy).toBe('function');
    mock.destroy();
  });

  it('connect returns an object with send/close and a connectionId', () => {
    const mock = createMockBrume();
    const conn = mock.connect(() => {});
    expect(conn.connectionId).toBeDefined();
    expect(typeof conn.send).toBe('function');
    expect(typeof conn.close).toBe('function');
    conn.close();
    mock.destroy();
  });

  it('sends a welcome brume:connected message on connect', () => {
    const mock = createMockBrume();
    const received: string[] = [];
    const conn = mock.connect((data) => received.push(data));
    expect(received.length).toBe(1);
    const parsed = JSON.parse(received[0]);
    expect(parsed.event).toBe('brume:connected');
    conn.close();
    mock.destroy();
  });

  it('tracks sent messages', () => {
    const mock = createMockBrume();
    const conn = mock.connect(() => {});
    conn.send(JSON.stringify({ event: 'message', channel: 'room:1', payload: { hi: true } }));
    const sent = mock.getSentMessages();
    expect(sent.length).toBe(1);
    expect(sent[0].event).toBe('message');
    expect(sent[0].channel).toBe('room:1');
    conn.close();
    mock.destroy();
  });

  it('delivers simulated messages to the message handler', () => {
    const mock = createMockBrume();
    const received: string[] = [];
    const conn = mock.connect((data) => received.push(data));
    // Welcome message already received (1). Simulate adds 1 more.
    mock.simulateMessage('room:1', 'message', { text: 'hello' });
    expect(received.length).toBe(2);
    const parsed = JSON.parse(received[1]);
    expect(parsed.event).toBe('message');
    expect(parsed.channel).toBe('room:1');
    conn.close();
    mock.destroy();
  });

  it('simulates system events', () => {
    const mock = createMockBrume();
    const received: string[] = [];
    const conn = mock.connect((data) => received.push(data));
    mock.simulateSystemEvent('room:1', 'ack', { ref: 'abc' });
    // Welcome (1) + simulated (1)
    expect(received.length).toBe(2);
    const parsed = JSON.parse(received[1]);
    expect(parsed.event).toBe('brume:ack');
    conn.close();
    mock.destroy();
  });

  it('simulates presence join/leave', () => {
    const mock = createMockBrume();
    const received: string[] = [];
    const conn = mock.connect((data) => received.push(data));
    mock.simulatePresenceJoin('room:1', 'conn-1', { name: 'Alice' });
    mock.simulatePresenceLeave('room:1', 'conn-1');
    // Welcome (1) + join (1) + leave (1)
    expect(received.length).toBe(3);
    const joinParsed = JSON.parse(received[1]);
    expect(joinParsed.event).toBe('brume:presence');
    conn.close();
    mock.destroy();
  });

  it('simulates acks', () => {
    const mock = createMockBrume();
    const received: string[] = [];
    const conn = mock.connect((data) => received.push(data));
    mock.simulateAck('room:1', 'ref-1');
    // Welcome (1) + ack (1)
    expect(received.length).toBe(2);
    const parsed = JSON.parse(received[1]);
    expect(parsed.event).toBe('brume:ack');
    expect(parsed.payload.ref).toBe('ref-1');
    conn.close();
    mock.destroy();
  });

  it('tracks connection count', () => {
    const mock = createMockBrume();
    expect(mock.connectionCount()).toBe(0);
    const conn1 = mock.connect(() => {});
    expect(mock.connectionCount()).toBe(1);
    const conn2 = mock.connect(() => {});
    expect(mock.connectionCount()).toBe(2);
    conn1.close();
    conn2.close();
    mock.destroy();
  });

  it('tracks subscribed channels', () => {
    const mock = createMockBrume();
    const conn = mock.connect(() => {});
    conn.send(JSON.stringify({ event: 'brume:join', channel: 'room:1' }));
    conn.send(JSON.stringify({ event: 'brume:join', channel: 'room:2' }));
    const channels = mock.getSubscribedChannels();
    expect(channels).toContain('room:1');
    expect(channels).toContain('room:2');
    conn.close();
    mock.destroy();
  });

  it('clears sent messages', () => {
    const mock = createMockBrume();
    const conn = mock.connect(() => {});
    conn.send(JSON.stringify({ event: 'message', channel: 'room:1' }));
    expect(mock.getSentMessages().length).toBe(1);
    mock.clearSent();
    expect(mock.getSentMessages().length).toBe(0);
    conn.close();
    mock.destroy();
  });
});
