// @brume/protocol - Shared protocol types and constants for Brume
// This package establishes a single source of truth for the wire protocol

// ─── System Events ───────────────────────────────────────────────────────────

/**
 * Reserved system event prefix. User events must never use this prefix.
 */
export const SYSTEM_PREFIX = 'brume:' as const;

/**
 * System events sent between client and server.
 */
export const SystemEvent = {
  // Client → Server
  Join: 'brume:join',
  Leave: 'brume:leave',
  PresenceUpdate: 'brume:presence_update',
  Ping: 'brume:ping',

  // Server → Client
  Ack: 'brume:ack',
  Pong: 'brume:pong',
  Presence: 'brume:presence',
  Error: 'brume:error',
  Connected: 'brume:connected',
} as const;

export type SystemEvent = (typeof SystemEvent)[keyof typeof SystemEvent];

/**
 * Client-to-server system events.
 */
export const ClientSystemEvent = {
  Join: SystemEvent.Join,
  Leave: SystemEvent.Leave,
  PresenceUpdate: SystemEvent.PresenceUpdate,
  Ping: SystemEvent.Ping,
} as const;

export type ClientSystemEvent = (typeof ClientSystemEvent)[keyof typeof ClientSystemEvent];

/**
 * Server-to-client system events.
 */
export const ServerSystemEvent = {
  Ack: SystemEvent.Ack,
  Pong: SystemEvent.Pong,
  Presence: SystemEvent.Presence,
  Error: SystemEvent.Error,
  Connected: SystemEvent.Connected,
} as const;

export type ServerSystemEvent = (typeof ServerSystemEvent)[keyof typeof ServerSystemEvent];

// ─── Error Codes ─────────────────────────────────────────────────────────────

/**
 * Error codes emitted in brume:error messages.
 */
export const ErrorCode = {
  AuthInvalid: 'AUTH_INVALID',
  AuthExpired: 'AUTH_EXPIRED',
  ChannelNotFound: 'CHANNEL_NOT_FOUND',
  RateLimited: 'RATE_LIMITED',
  PlanLimit: 'PLAN_LIMIT',
  PayloadTooLarge: 'PAYLOAD_TOO_LARGE',
  InvalidMessage: 'INVALID_MESSAGE',
  SlowConsumer: 'SLOW_CONSUMER',
} as const;

export type ErrorCode = (typeof ErrorCode)[keyof typeof ErrorCode];

// ─── Message Types ───────────────────────────────────────────────────────────

/**
 * The single envelope shared by all client-server and server-client messages.
 */
export interface Message<P = unknown> {
  /** Event name (e.g., "message", "brume:join", "brume:ack") */
  event: string;
  /**
   * Channel name (e.g., "room:123"). Omitted for connection-scoped system
   * events such as `brume:pong` and `brume:connected`.
   */
  channel?: string;
  /** Arbitrary JSON payload */
  payload?: P;
  /** Client-generated idempotency key for ack correlation */
  ref?: string;
  /** Unix timestamp in milliseconds when the message was created */
  timestamp?: number;
}

/**
 * Client message structure for parsing incoming messages.
 */
export interface ClientMessage {
  /** Event name */
  event: string;
  /** Channel name (required for join/leave/user messages) */
  channel?: string;
  /** Arbitrary JSON payload */
  payload?: unknown;
  /** Client-generated idempotency key */
  ref?: string;
}

/**
 * Error message payload.
 */
export interface BrumeError {
  /** Error code */
  code: ErrorCode;
  /** Human-readable error message */
  message: string;
}

/**
 * Ack message payload.
 */
export interface AckPayload {
  /** The ref from the original message */
  ref?: string;
}

/**
 * Presence update payload.
 */
export interface PresenceUpdatePayload {
  /** Type of presence event */
  type: 'join' | 'leave' | 'update';
  /** Connection ID */
  connection_id: string;
  /** Arbitrary state data */
  state?: Record<string, unknown>;
}

/**
 * Connected/welcome message payload.
 */
export interface ConnectedPayload {
  /** Connection ID assigned by server */
  connection_id: string;
  /** Project ID (hex-encoded) */
  project_id: string;
}

/**
 * Presence user entry in a roster snapshot.
 */
export interface PresenceUser {
  /** User/connection ID */
  user_id: string;
  /** Current presence state */
  state: Record<string, unknown>;
  /** Unix timestamp of last update */
  updated_at: number;
}

// ─── Constants ───────────────────────────────────────────────────────────────

/**
 * Maximum payload size: 64KB.
 */
export const MAX_PAYLOAD_SIZE = 64 * 1024;

/**
 * Maximum messages per second per connection.
 */
export const MAX_MESSAGES_PER_SEC = 100;

/**
 * Server-side ping interval in seconds.
 */
export const PING_INTERVAL_SECS = 30;

/**
 * Client-side ping interval in milliseconds.
 */
export const PING_INTERVAL_MS = 30_000;

/**
 * Default ack timeout in milliseconds.
 */
export const ACK_TIMEOUT_MS = 10_000;

/**
 * Initial reconnect delay in milliseconds.
 */
export const RECONNECT_INITIAL_MS = 100;

/**
 * Maximum reconnect delay in milliseconds.
 */
export const RECONNECT_MAX_MS = 30_000;

/**
 * Maximum channel name length.
 */
export const MAX_CHANNEL_NAME_LENGTH = 256;

// ─── Validation ──────────────────────────────────────────────────────────────

/**
 * Validate a channel name against naming conventions.
 *
 * Rules:
 * - Must not be empty
 * - Must not exceed 256 characters
 * - Must not start with `brume:` (reserved for system events)
 * - Must contain only alphanumeric characters, `:`, `-`, `_`
 * - Must contain at least one `:` separator (namespace convention)
 *
 * Note (P2-2, audit 2026-06-14): channel names and event names have
 * different allowed character sets. Channel names allow
 * `[A-Za-z0-9:_-]`. Event names additionally allow `.` (dot), so
 * events like `user.joined` are valid but channels like `user.room`
 * are not. This asymmetry is intentional — channel names are used as
 * URL path segments where `.` has no special meaning, but event names
 * benefit from hierarchical dot-separation for consumer routing.
 *
 * @param name - Channel name to validate
 * @returns true if valid, error message string if invalid
 */
export function validateChannelName(name: string): true | string {
  if (name.length === 0) {
    return 'Channel name must not be empty';
  }
  if (name.length > MAX_CHANNEL_NAME_LENGTH) {
    return `Channel name must not exceed ${MAX_CHANNEL_NAME_LENGTH} characters`;
  }
  if (name.startsWith(SYSTEM_PREFIX)) {
    return "Channel names must not start with 'brume:' (reserved for system events)";
  }
  if (!/^[\w:-]+$/.test(name)) {
    return "Channel names must contain only alphanumeric characters, ':', '-', '_'";
  }
  if (!name.includes(':')) {
    return "Channel names must contain at least one ':' separator (e.g., 'room:123')";
  }
  return true;
}

/**
 * Check if an event name is a system event.
 */
export function isSystemEvent(event: string): boolean {
  return event.startsWith(SYSTEM_PREFIX);
}

/**
 * Check if a system event is allowed from clients.
 */
export function isAllowedClientSystemEvent(event: string): boolean {
  return (
    event === SystemEvent.Join ||
    event === SystemEvent.Leave ||
    event === SystemEvent.PresenceUpdate ||
    event === SystemEvent.Ping
  );
}

/**
 * Type guard: narrows a string to a client-to-server system event name.
 */
export function isClientSystemEvent(event: string): event is ClientSystemEvent {
  return isAllowedClientSystemEvent(event);
}

/**
 * Validate a client message.
 *
 * @param msg - Client message to validate
 * @returns true if valid, error message string if invalid
 */
export function validateClientMessage(msg: ClientMessage): true | string {
  // Check if it's a system event
  if (isSystemEvent(msg.event)) {
    // Only allow specific client-to-server system events
    if (!isAllowedClientSystemEvent(msg.event)) {
      return "System events with 'brume:' prefix are reserved";
    }
  }

  // Check channel requirement for certain events
  const requiresChannel: ReadonlySet<ClientSystemEvent> = new Set([
    SystemEvent.Join,
    SystemEvent.Leave,
    SystemEvent.PresenceUpdate,
  ]);
  if (
    isClientSystemEvent(msg.event) &&
    requiresChannel.has(msg.event) &&
    !msg.channel
  ) {
    return `Missing 'channel' field in ${msg.event}`;
  }

  return true;
}
