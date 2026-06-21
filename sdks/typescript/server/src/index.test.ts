import { beforeEach, describe, expect, it, vi } from 'vitest';

import { generateToken } from './index';

describe('generateToken', () => {
  const secret = 'test-secret-key-for-unit-tests';
  const validProjectId = 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6';

  it('returns a string', () => {
    const token = generateToken(secret, { projectId: validProjectId, tier: 'free' });
    expect(typeof token).toBe('string');
    expect(token.split('.')).toHaveLength(3);
  });

  it('defaults to free tier', () => {
    const token = generateToken(secret, { projectId: validProjectId });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    expect(payload.tier).toBe('free');
  });

  it('includes the project_id as base64', () => {
    const token = generateToken(secret, { projectId: validProjectId });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    expect(payload.project_id).toBeDefined();
  });

  it('includes the gateway-required iss, aud, and verified claims', () => {
    const token = generateToken(secret, { projectId: validProjectId });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    expect(payload.iss).toBe('brume');
    expect(payload.aud).toBe('brume');
    expect(payload.verified).toBe(true);
    expect(payload.nbf).toBe(payload.iat);
  });

  it('uses custom expiry', () => {
    const token = generateToken(secret, { projectId: validProjectId, expirySeconds: 7200 });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    const iat = payload.iat;
    const exp = payload.exp;
    expect(exp - iat).toBe(7200);
  });

  it('uses default expiry of 1 hour', () => {
    const token = generateToken(secret, { projectId: validProjectId });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    const exp = payload.exp;
    const iat = payload.iat;
    expect(exp - iat).toBe(3600);
  });

  it('supports all tier values', () => {
    for (const tier of ['free', 'starter', 'pro', 'business'] as const) {
      const token = generateToken(secret, { projectId: validProjectId, tier });
      const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
      expect(payload.tier).toBe(tier);
    }
  });

  it('includes channels array', () => {
    const token = generateToken(secret, {
      projectId: validProjectId,
      channels: ['room:1', 'room:2'],
    });
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString());
    expect(payload.channels).toEqual(['room:1', 'room:2']);
  });
});

describe('publishTo', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('exists as a function', async () => {
    const { publishTo } = await import('./index');
    expect(typeof publishTo).toBe('function');
  });

  it('throws on network error', async () => {
    const { publishTo } = await import('./index');
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('Network error')));
    await expect(
      publishTo({
        baseUrl: 'http://localhost:8080',
        secretKey: 'sk_test',
        channel: 'room:1',
        event: 'test',
        payload: {},
      }),
    ).rejects.toThrow();
    vi.unstubAllGlobals();
  });
});
