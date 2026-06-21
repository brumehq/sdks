import { describe, it, expect } from 'vitest';
import { formatPlanLimit, isPlanLimit, type PlanLimitPayload } from './error-helpers';

describe('formatPlanLimit (server / REST transport)', () => {
  it('formats a connections_cap_reached payload with upgrade hint', () => {
    const payload: PlanLimitPayload = {
      code: 'PLAN_LIMIT',
      reason: 'connections_cap_reached',
      current: 100,
      limit: 100,
      upgradeTier: 'starter',
      message: 'Connection cap reached (100/100). Upgrade to starter.',
    };
    const out = formatPlanLimit(payload);
    expect(out.headline).toMatch(/connection cap/i);
    expect(out.upgradeTier).toBe('starter');
    expect(out.upgradeUrl).toMatch(/\/pricing\?tier=starter&reason=connections_cap_reached/);
    expect(out.body).toContain('100 / 100');
  });

  it('handles null limit (informational)', () => {
    const out = formatPlanLimit({
      code: 'PLAN_LIMIT',
      reason: 'channels_cap_reached',
      current: 100_000,
      limit: null,
      upgradeTier: 'business',
      message: '',
    });
    expect(out.upgradeTier).toBe('business');
    expect(out.body).toContain('unlimited');
  });

  it('omits upgradeTier when null (top tier)', () => {
    const out = formatPlanLimit({
      code: 'PLAN_LIMIT',
      reason: 'connections_cap_reached',
      current: 25_000,
      limit: 20_000,
      upgradeTier: null,
      message: '',
    });
    expect(out.upgradeTier).toBeNull();
    expect(out.topTier).toBe(true);
    expect(out.upgradeUrl).toBe('/pricing');
  });
});

describe('isPlanLimit', () => {
  it('matches a PLAN_LIMIT payload', () => {
    const p: PlanLimitPayload = {
      code: 'PLAN_LIMIT',
      reason: 'channels_cap_reached',
      current: 25,
      limit: 25,
      upgradeTier: 'starter',
      message: '',
    };
    expect(isPlanLimit(p)).toBe(true);
  });

  it('rejects a non-PLAN_LIMIT error', () => {
    expect(isPlanLimit({ code: 'PAYLOAD_TOO_LARGE' })).toBe(false);
    expect(isPlanLimit(undefined)).toBe(false);
    expect(isPlanLimit(42)).toBe(false);
  });
});
