/**
 * PLAN_LIMIT payload formatter for `@brume/client`.
 *
 * Mirrors the wire shape the gateway emits via `BrumeMessage::plan_limit`
 * (Rust). SDK consumers receive `brume:error` frames with a `code` of
 * `PLAN_LIMIT` and a `reason`/`current`/`limit`/`upgradeTier` payload;
 * `formatPlanLimit` normalizes that into a stable, human-presentable
 * shape with a precomputed upgrade URL.
 */

export type PlanLimitReason =
  | 'connections_cap_reached'
  | 'channels_cap_reached'
  | 'msgs_per_sec_cap_reached'
  | 'tables_cap_reached'
  | 'webhooks_cap_reached'
  | 'projects_cap_reached'
  | 'seats_cap_reached';

export type UpgradeTier = 'starter' | 'pro' | 'business';

export interface PlanLimitPayload {
  code: 'PLAN_LIMIT';
  reason: PlanLimitReason;
  current: number;
  limit: number | null;
  upgradeTier: UpgradeTier | null;
  message: string;
}

export interface FormattedPlanLimit {
  headline: string;
  body: string;
  upgradeTier: UpgradeTier | null;
  /** Pre-built upgrade URL with reason + tier query params. `/pricing` when on the top tier. */
  upgradeUrl: string;
  /** True when the customer is already on the largest tier (no upgrade path). */
  topTier: boolean;
}

const HEADLINES: Record<PlanLimitReason, string> = {
  connections_cap_reached: 'Connection cap reached',
  channels_cap_reached: 'Channel cap reached',
  msgs_per_sec_cap_reached: 'Messages-per-second cap reached',
  tables_cap_reached: 'Postgres-tables cap reached',
  webhooks_cap_reached: 'Webhook destination cap reached',
  projects_cap_reached: 'Projects-per-workspace cap reached',
  seats_cap_reached: 'Team seats cap reached',
};

export function formatPlanLimit(payload: PlanLimitPayload): FormattedPlanLimit {
  const headline = HEADLINES[payload.reason];
  const limitText = payload.limit === null ? 'unlimited' : String(payload.limit);
  const body = `${payload.current} / ${limitText} on the current tier.`;
  const upgradeUrl = payload.upgradeTier
    ? `/pricing?tier=${payload.upgradeTier}&reason=${payload.reason}`
    : '/pricing';
  return {
    headline,
    body,
    upgradeTier: payload.upgradeTier,
    upgradeUrl,
    topTier: payload.upgradeTier === null,
  };
}

/**
 * Type guard: is this error payload a PLAN_LIMIT we can format?
 * Returns false for non-PLAN_LIMIT errors (auth, payload, slow consumer, etc.).
 */
export function isPlanLimit(payload: unknown): payload is PlanLimitPayload {
  if (typeof payload !== 'object' || payload === null) return false;
  const p = payload as Record<string, unknown>;
  return p.code === 'PLAN_LIMIT' && typeof p.reason === 'string' && typeof p.current === 'number';
}
