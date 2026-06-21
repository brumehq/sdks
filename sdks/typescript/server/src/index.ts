import { ACK_TIMEOUT_MS } from '@brume/protocol';
import jwt from 'jsonwebtoken';

// ─── Types ─────────────────────────────────────────────────────────────────────

export interface TokenOptions {
  /**
   * Project ID as a UUID string (e.g., "550e8400-e29b-41d4-a716-446655440000")
   * or a hex string without dashes (e.g., "550e8400e29b41d4a716446655440000").
   */
  projectId: string;
  tier?: 'free' | 'starter' | 'pro' | 'business';
  /** Allowed channels. Empty means all channels are allowed. */
  channels?: string[];
  /** Token lifetime in seconds. Defaults to 3600 (1 hour). */
  expirySeconds?: number;
}

export interface PublishOptions {
  baseUrl: string;
  secretKey: string;
  channel: string;
  event: string;
  payload: Record<string, unknown>;
  ref?: string;
  /** Request timeout in milliseconds. Defaults to 10000 (10s). */
  timeoutMs?: number;
}

/**
 * Convert a UUID string to a Uint8Array.
 *
 * Accepts formats:
 * - "550e8400-e29b-41d4-a716-446655440000" (with dashes)
 * - "550e8400e29b41d4a716446655440000" (without dashes)
 *
 * Returns a Uint8Array instead of a JSON number array to avoid
 * precision loss when serialized (JSON numbers can exceed IEEE 754
 * safe-integer range for large byte values).
 */
function uuidToBytes(uuid: string): Uint8Array {
  const hex = uuid.replace(/-/g, '');
  if (hex.length !== 32) {
    throw new Error(`Invalid project ID: expected 32 hex characters, got ${hex.length}`);
  }
  const bytes = new Uint8Array(16);
  for (let i = 0; i < hex.length; i += 2) {
    bytes[i / 2] = Number.parseInt(hex.slice(i, i + 2), 16);
  }
  return bytes;
}

// ─── generateToken ────────────────────────────────────────────────────────────

/**
 * Generate a JWT token for a Brume client connection.
 *
 * The token is validated by the Brume server on WebSocket upgrade.
 * It contains the project identity, tier, and expiration.
 *
 * @param jwtSecret — The `BRUME_JWT_SECRET` value from your server config
 * @param options — Token options including project ID and tier
 * @returns A JWT token string to pass to `createClient({ token: ... })`
 *
 * @example
 * ```ts
 * const token = generateToken(process.env.BRUME_JWT_SECRET, {
 *   projectId: "550e8400-e29b-41d4-a716-446655440000",
 *   tier: "free",
 *   expirySeconds: 3600,
 * })
 *
 * const client = createClient({
 *   url: "https://brume.example.com",
 *   token: token,
 * })
 * ```
 */
// Matches the contract enforced by `crates/core/src/auth/jwt.rs`.
const BRUME_ISSUER = 'brume';
const BRUME_AUDIENCE = 'brume';

export function generateToken(jwtSecret: string | Buffer, options: TokenOptions): string {
  const now = Math.floor(Date.now() / 1000);
  const claims: Record<string, unknown> = {
    project_id: uuidToBytes(options.projectId),
    tier: options.tier ?? 'free',
    iat: now,
    nbf: now,
    exp: now + (options.expirySeconds ?? 3600),
    iss: BRUME_ISSUER,
    aud: BRUME_AUDIENCE,
    verified: true,
  };
  if (options.channels) {
    claims.channels = options.channels;
  }
  return jwt.sign(claims, jwtSecret, { algorithm: 'HS256' });
}

// ─── publishTo ─────────────────────────────────────────────────────────────────────

/**
 * Publish a message to a Brume channel via the REST API.
 *
 * Use this from server-side code (cron jobs, webhooks, queue workers)
 * to send messages to WebSocket clients without maintaining a connection.
 *
 * @param options — Publish options including channel, event, and payload
 * @returns The number of recipients that received the message
 *
 * @example
 * ```ts
 * await publishTo({
 *   baseUrl: "https://brume.example.com",
 *   secretKey: process.env.BRUME_API_KEY,
 *   channel: "room:123",
 *   event: "message",
 *   payload: { text: "Hello from the server!" },
 * })
 * ```
 */
export async function publishTo(options: PublishOptions): Promise<{ recipients: number }> {
  const url = new URL(
    `/v1/channels/${encodeURIComponent(options.channel)}/publish`,
    options.baseUrl,
  );

  const body = {
    event: options.event,
    payload: options.payload,
    ref: options.ref,
  };

  const controller = new AbortController();
  const timeoutMs = options.timeoutMs ?? ACK_TIMEOUT_MS;
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url.toString(), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${options.secretKey}`,
      },
      body: JSON.stringify(body),
      signal: controller.signal,
    });

    if (!response.ok) {
      const text = await response.text().catch(() => 'Unknown error');
      throw new Error(`Publish failed (${response.status}): ${text}`);
    }

    return response.json() as Promise<{ recipients: number }>;
  } finally {
    clearTimeout(timeoutId);
  }
}

export {
  formatPlanLimit,
  isPlanLimit,
  type FormattedPlanLimit,
  type PlanLimitPayload,
  type PlanLimitReason,
  type UpgradeTier,
} from './error-helpers';
