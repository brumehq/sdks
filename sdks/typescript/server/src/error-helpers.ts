/**
 * PLAN_LIMIT payload formatter for `@brume/server` (REST transport).
 *
 * Same shape as `@brume/client`'s `formatPlanLimit`. The two formatters
 * are kept structurally identical so a future REST-only change to the
 * gateway doesn't pull client consumers, and vice versa. Tests pin the
 * equality of the public surface in both packages.
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
  upgradeUrl: string;
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

export function isPlanLimit(payload: unknown): payload is PlanLimitPayload {
  if (typeof payload !== 'object' || payload === null) return false;
  const p = payload as Record<string, unknown>;
  return p.code === 'PLAN_LIMIT' && typeof p.reason === 'string' && typeof p.current === 'number';
}
