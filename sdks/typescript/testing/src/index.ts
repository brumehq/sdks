// @brume/testing — In-process mock Brume server for unit/integration tests.
//
// Usage:
//   import { createMockBrume } from '@brume/testing';
//   import { createClient } from '@brume/client';
//
//   const mock = createMockBrume();
//   const client = createClient({ url: mock.url, token: () => 'test-token' });
//
//   // Simulate server sending a message
//   mock.simulateMessage('room:1', 'message', { text: 'hello' });
//
//   // Inspect what clients sent
//   const sent = mock.getSentMessages();
//
//   // Clean up
//   mock.destroy();

import type {
  AckPayload,
  ClientMessage,
  ConnectedPayload,
  Message,
  PresenceUpdatePayload,
} from '@brume/protocol';
import { SYSTEM_PREFIX, SystemEvent } from '@brume/protocol';

export interface MockBrume {
  url: string;

  connect(onMessage: (data: string) => void): {
    send: (data: string) => void;
    close: () => void;
    connectionId: string;
  };

  simulateMessage(channel: string, event: string, payload?: unknown): void;
  simulateSystemEvent(channel: string, event: string, payload?: unknown): void;
  simulatePresenceJoin(channel: string, connectionId: string, state?: unknown): void;
  simulatePresenceLeave(channel: string, connectionId: string): void;
  simulateAck(channel: string, ref: string): void;

  waitForSend(timeoutMs?: number): Promise<ClientMessage>;
  getSentMessages(): ClientMessage[];
  getChannelMessages(channel: string): ClientMessage[];
  clearSent(): void;
  connectionCount(): number;
  getSubscribedChannels(): string[];
  destroy(): void;
}

interface MockConnection {
  id: string;
  messageHandler: (data: string) => void;
  closed: boolean;
}

/**
 * Create an in-process mock Brume server for testing.
 *
 * The mock intercepts WebSocket-level communication and provides
 * helpers to simulate server behavior and inspect client actions.
 *
 * Note: The mock operates at the message level. To use it with
 * `createClient`, you'll need to mock the WebSocket constructor
 * in your test environment to route through the mock.
 */
export function createMockBrume(): MockBrume {
  const connections: MockConnection[] = [];
  const sentMessages: ClientMessage[] = [];
  const subscribedChannels = new Set<string>();
  const pendingWaits: Array<{
    resolve: (value: ClientMessage) => void;
    timer: ReturnType<typeof setTimeout>;
  }> = [];

  let connectionCounter = 0;

  function broadcastToConnections(message: string): void {
    for (const conn of connections) {
      if (!conn.closed) {
        try {
          conn.messageHandler(message);
        } catch {
          // Client handler threw — ignore
        }
      }
    }
  }

  function buildAck(channel: string, ref: string | undefined): string {
    const payload: AckPayload = { ref };
    const msg: Message<AckPayload> = {
      event: SystemEvent.Ack,
      channel,
      payload,
      timestamp: Date.now(),
    };
    return JSON.stringify(msg);
  }

  function handleClientMessage(connId: string, raw: string): void {
    let parsed: unknown;
    try {
      parsed = JSON.parse(raw);
    } catch {
      return;
    }

    if (!isClientMessage(parsed)) 
return;
    const msg = parsed;

    sentMessages.push(msg);

    // Resolve any pending waitForSend
    if (pendingWaits.length > 0) {
      const wait = pendingWaits.shift()!;
      clearTimeout(wait.timer);
      wait.resolve(msg);
    }

    const { event, channel } = msg;

    if (event === SystemEvent.Join && channel) {
      subscribedChannels.add(channel);

      // Send ack
      const conn = connections.find((c) => c.id === connId);
      if (conn && !conn.closed) {
        conn.messageHandler(buildAck(channel, msg.ref));
      }

      // Send connected presence roster if payload provided
      if (msg.payload) {
        const presencePayload: PresenceUpdatePayload = {
          type: 'join',
          connection_id: connId,
          state: msg.payload as Record<string, unknown>,
        };
        const presenceMsg: Message<PresenceUpdatePayload> = {
          event: SystemEvent.Presence,
          channel,
          payload: presencePayload,
          timestamp: Date.now(),
        };
        broadcastToConnections(JSON.stringify(presenceMsg));
      }
    } else if (event === SystemEvent.Leave && channel) {
      subscribedChannels.delete(channel);
    } else if (event === SystemEvent.Ping) {
      const conn = connections.find((c) => c.id === connId);
      if (conn && !conn.closed) {
        const pongMsg: Message<Record<string, never>> = {
          event: SystemEvent.Pong,
          payload: {},
          timestamp: Date.now(),
        };
        conn.messageHandler(JSON.stringify(pongMsg));
      }
    } else if (msg.ref && channel) {
      // Auto-ack user messages
      const conn = connections.find((c) => c.id === connId);
      if (conn && !conn.closed) {
        conn.messageHandler(buildAck(channel, msg.ref));
      }
    }
  }

  return {
    url: 'http://mock-brume.test',

    connect(onMessage) {
      const connId = `mock-conn-${++connectionCounter}`;
      const conn: MockConnection = {
        id: connId,
        messageHandler: onMessage,
        closed: false,
      };
      connections.push(conn);

      // Send welcome message
      const welcomePayload: ConnectedPayload = {
        connection_id: connId,
        project_id: 'mock-project',
      };
      const welcomeMsg: Message<ConnectedPayload> = {
        event: SystemEvent.Connected,
        channel: '',
        payload: welcomePayload,
        timestamp: Date.now(),
      };
      onMessage(JSON.stringify(welcomeMsg));

      return {
        send: (data: string) => {
          if (!conn.closed) {
            handleClientMessage(connId, data);
          }
        },
        close: () => {
          conn.closed = true;
          const idx = connections.indexOf(conn);
          if (idx !== -1) 
connections.splice(idx, 1);
        },
        connectionId: connId,
      };
    },

    simulateMessage(channel, event, payload = {}) {
      const msg: Message<unknown> = {
        event,
        channel,
        payload,
        timestamp: Date.now(),
      };
      broadcastToConnections(JSON.stringify(msg));
    },

    simulateSystemEvent(channel, event, payload = {}) {
      const fullEvent = event.startsWith(SYSTEM_PREFIX) ? event : `${SYSTEM_PREFIX}${event}`;
      this.simulateMessage(channel, fullEvent, payload);
    },

    simulatePresenceJoin(channel, connectionId, state = {}) {
      const presencePayload: PresenceUpdatePayload = {
        type: 'join',
        connection_id: connectionId,
        state: state as Record<string, unknown>,
      };
      const msg: Message<PresenceUpdatePayload> = {
        event: SystemEvent.Presence,
        channel,
        payload: presencePayload,
        timestamp: Date.now(),
      };
      broadcastToConnections(JSON.stringify(msg));
    },

    simulatePresenceLeave(channel, connectionId) {
      const presencePayload: PresenceUpdatePayload = {
        type: 'leave',
        connection_id: connectionId,
      };
      const msg: Message<PresenceUpdatePayload> = {
        event: SystemEvent.Presence,
        channel,
        payload: presencePayload,
        timestamp: Date.now(),
      };
      broadcastToConnections(JSON.stringify(msg));
    },

    simulateAck(channel, ref) {
      broadcastToConnections(buildAck(channel, ref));
    },

    waitForSend(timeoutMs = 5000): Promise<ClientMessage> {
      return new Promise((resolve, reject) => {
        const timer = setTimeout(() => {
          const idx = pendingWaits.findIndex((w) => w.timer === timer);
          if (idx !== -1) 
pendingWaits.splice(idx, 1);
          reject(new Error(`waitForSend timed out after ${timeoutMs}ms`));
        }, timeoutMs);
        pendingWaits.push({ resolve, timer });
      });
    },

    getSentMessages() {
      return [...sentMessages];
    },

    getChannelMessages(channel) {
      return sentMessages.filter((m) => m.channel === channel);
    },

    clearSent() {
      sentMessages.length = 0;
    },

    connectionCount() {
      return connections.filter((c) => !c.closed).length;
    },

    getSubscribedChannels() {
      return [...subscribedChannels];
    },

    destroy() {
      for (const conn of connections) {
        conn.closed = true;
      }
      connections.length = 0;
      for (const wait of pendingWaits) {
        clearTimeout(wait.timer);
      }
      pendingWaits.length = 0;
      sentMessages.length = 0;
      subscribedChannels.clear();
    },
  };
}

function isClientMessage(value: unknown): value is ClientMessage {
  if (typeof value !== 'object' || value === null) 
return false;
  const obj = value as Record<string, unknown>;
  if (typeof obj.event !== 'string') 
return false;
  if (obj.channel !== undefined && typeof obj.channel !== 'string') 
return false;
  if (obj.ref !== undefined && typeof obj.ref !== 'string') 
return false;
  return true;
}
