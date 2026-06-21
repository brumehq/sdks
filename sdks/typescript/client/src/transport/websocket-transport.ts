import { SystemEvent } from '@brume/protocol';
import type { BrumeError, ClientMessage, Message } from '@brume/protocol';

import type { Transport, TransportOptions } from './types';

function isWireMessage(value: unknown): value is ClientMessage | Message {
  if (typeof value !== 'object' || value === null) return false;
  const obj = value as Record<string, unknown>;
  return typeof obj.event === 'string';
}

function isBrumeError(value: unknown): value is BrumeError {
  if (typeof value !== 'object' || value === null) return false;
  const obj = value as Record<string, unknown>;
  return typeof obj.code === 'string' && typeof obj.message === 'string';
}

// Subprotocol offered to the gateway during the WebSocket handshake.
// The gateway picks one of the offered protocols and echoes it back in
// its `Sec-WebSocket-Protocol` response. The token lives inside the
// subprotocol header so it never appears in the URL — which means it
// won't leak into access logs, browser history, or referer headers.
//
// See crates/core/src/server/mod.rs (the `brume.v1, brume.token.<jwt>`
// subprotocol handling) and crates/core/tests/jwt_integration.rs
// (which exercises both subprotocol and legacy `?token=` paths).
const SUBPROTOCOL_VERSION = 'brume.v1';
const SUBPROTOCOL_TOKEN_PREFIX = 'brume.token.';

export class WebSocketTransport implements Transport {
  readonly kind = 'websocket' as const;
  private ws: WebSocket | null = null;
  private closedByUs = false;
  private opts: TransportOptions | null = null;

  open(opts: TransportOptions): void {
    this.opts = opts;
    this.closedByUs = false;
    opts.onStateChange('connecting');

    const authMode = opts.auth ?? 'subprotocol';
    const wsBase = `${opts.url.replace(/^http/, 'ws')}/v1/connect`;

    let ws: WebSocket;
    try {
      if (authMode === 'subprotocol') {
        // Recommended path: put the token in `Sec-WebSocket-Protocol`.
        // The server must echo back one of the offered subprotocols for
        // the handshake to complete — the browser enforces this.
        ws = new WebSocket(wsBase, [
          SUBPROTOCOL_VERSION,
          `${SUBPROTOCOL_TOKEN_PREFIX}${opts.token}`,
        ]);
      } else {
        // Legacy path: `?token=` query parameter. Server still accepts
        // this (with a deprecation warning) for backwards compatibility
        // with older gateways that haven't been upgraded.
        ws = new WebSocket(`${wsBase}?token=${encodeURIComponent(opts.token)}`);
      }
    } catch {
      opts.onStateChange('failed');
      opts.onEvent({ type: 'error', error: new Error('WebSocket constructor threw') });
      return;
    }
    this.ws = ws;

    ws.onopen = (): void => {
      if (this.closedByUs) return;
      opts.onStateChange('connected');
      opts.onEvent({ type: 'open' });
    };

    ws.onmessage = (ev: MessageEvent): void => {
      if (typeof ev.data !== 'string') return;
      let parsed: unknown;
      try {
        parsed = JSON.parse(ev.data);
      } catch {
        return;
      }
      if (!isWireMessage(parsed)) return;
      const msg = parsed;

      if (msg.event === SystemEvent.Error && isBrumeError(msg.payload)) {
        if (msg.payload.code === 'AUTH_EXPIRED') {
          this.ws?.close();
          return;
        }
      }

      opts.onMessage(msg);
    };

    ws.onclose = (ev: CloseEvent): void => {
      if (this.closedByUs) {
        opts.onStateChange('disconnected');
        opts.onEvent({ type: 'close', code: ev.code, reason: ev.reason });
        return;
      }
      opts.onStateChange('reconnecting');
      opts.onEvent({ type: 'close', code: ev.code, reason: ev.reason });
    };

    ws.onerror = (): void => {
      opts.onEvent({ type: 'error', error: new Error('WebSocket error') });
      ws.close();
    };
  }

  close(): void {
    this.closedByUs = true;
    this.ws?.close();
    this.ws = null;
  }

  send(msg: ClientMessage): void {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(msg));
    }
  }

  isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN;
  }
}
