import type { ClientMessage, Message } from '@brume/protocol';

export type TransportState =
  | 'connecting'
  | 'connected'
  | 'reconnecting'
  | 'disconnected'
  | 'failed';

export type TransportEvent =
  | { type: 'open' }
  | { type: 'close'; code?: number; reason?: string }
  | { type: 'error'; error: Error };

export type TransportKind = 'websocket' | 'sse' | 'longpoll';

export type AuthMode = 'subprotocol' | 'query';

export interface TransportOptions {
  url: string;
  token: string;
  /**
   * How the WebSocket transport carries the JWT to the gateway.
   *  - `subprotocol` (default, recommended): token travels inside
   *    `Sec-WebSocket-Protocol: brume.v1, brume.token.<jwt>`. Never
   *    appears in the URL → no leak via access logs / referer.
   *  - `query`: legacy `?token=<jwt>` path. Still accepted by the
   *    gateway (with a deprecation warning) for backwards compat.
   * The SSE and long-poll transports ignore this option and always
   * use the query path because `EventSource` and `fetch` don't
   * support custom headers.
   */
  auth?: AuthMode;
  onMessage: (msg: ClientMessage | Message) => void;
  onEvent: (ev: TransportEvent) => void;
  onStateChange: (state: TransportState) => void;
}

export interface Transport {
  readonly kind: TransportKind;
  open(opts: TransportOptions): void;
  close(): void;
  send(msg: ClientMessage): void;
  isConnected(): boolean;
  setChannel?(channel: string): void;
  restart?(): void;
}
