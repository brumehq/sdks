import { describe, expect, it } from 'vitest';

import {
  isAllowedClientSystemEvent,
  isClientSystemEvent,
  isSystemEvent,
  MAX_CHANNEL_NAME_LENGTH,
  MAX_PAYLOAD_SIZE,
  SystemEvent,
  validateChannelName,
  validateClientMessage,
} from './index';

// ─── validateChannelName ─────────────────────────────────────────────────────

describe('validateChannelName', () => {
  it('accepts a valid channel name with namespace separator', () => {
    expect(validateChannelName('room:123')).toBe(true);
    expect(validateChannelName('chat:general')).toBe(true);
    expect(validateChannelName('db:orders')).toBe(true);
  });

  it('accepts names with hyphens and underscores', () => {
    expect(validateChannelName('private-room:123')).toBe(true);
    expect(validateChannelName('user_settings:updated')).toBe(true);
  });

  it('rejects empty names', () => {
    expect(validateChannelName('')).not.toBe(true);
  });

  it('rejects names exceeding 256 characters', () => {
    const long = 'a'.repeat(MAX_CHANNEL_NAME_LENGTH + 1);
    expect(validateChannelName(`x:${long}`)).not.toBe(true);
  });

  it('accepts names at exactly 256 characters', () => {
    // "x:" = 2 chars, then 254 more
    const name = `x:${'a'.repeat(254)}`;
    expect(name.length).toBe(MAX_CHANNEL_NAME_LENGTH);
    expect(validateChannelName(name)).toBe(true);
  });

  it('rejects names starting with brume: (reserved)', () => {
    expect(validateChannelName('brume:join')).not.toBe(true);
    expect(validateChannelName('brume:custom')).not.toBe(true);
  });

  it('rejects names with dots (asymmetry with event names)', () => {
    expect(validateChannelName('user.room:123')).not.toBe(true);
  });

  it('rejects names with spaces', () => {
    expect(validateChannelName('room: 123')).not.toBe(true);
  });

  it('rejects names with special characters', () => {
    expect(validateChannelName('room:123!')).not.toBe(true);
    expect(validateChannelName('room:123/')).not.toBe(true);
    expect(validateChannelName('room:123#')).not.toBe(true);
  });

  it('rejects names without a colon separator', () => {
    expect(validateChannelName('room123')).not.toBe(true);
    expect(validateChannelName('justtext')).not.toBe(true);
  });
});

// ─── validateClientMessage ───────────────────────────────────────────────────

describe('validateClientMessage', () => {
  it('accepts a user event message', () => {
    expect(validateClientMessage({ event: 'message', channel: 'room:1' })).toBe(true);
  });

  it('accepts brume:join with channel', () => {
    expect(
      validateClientMessage({ event: SystemEvent.Join, channel: 'room:1' }),
    ).toBe(true);
  });

  it('accepts brume:leave with channel', () => {
    expect(
      validateClientMessage({ event: SystemEvent.Leave, channel: 'room:1' }),
    ).toBe(true);
  });

  it('accepts brume:presence_update with channel', () => {
    expect(
      validateClientMessage({ event: SystemEvent.PresenceUpdate, channel: 'room:1' }),
    ).toBe(true);
  });

  it('accepts brume:ping without channel', () => {
    expect(validateClientMessage({ event: SystemEvent.Ping })).toBe(true);
  });

  it('rejects brume:join without channel', () => {
    expect(validateClientMessage({ event: SystemEvent.Join })).not.toBe(true);
  });

  it('rejects brume:leave without channel', () => {
    expect(validateClientMessage({ event: SystemEvent.Leave })).not.toBe(true);
  });

  it('rejects unknown brume: system events', () => {
    expect(
      validateClientMessage({ event: 'brume:custom', channel: 'room:1' }),
    ).not.toBe(true);
    expect(
      validateClientMessage({ event: 'brume:error', channel: 'room:1' }),
    ).not.toBe(true);
  });
});

// ─── isSystemEvent / isAllowedClientSystemEvent / isClientSystemEvent ─────────

describe('isSystemEvent', () => {
  it('returns true for brume: prefixed events', () => {
    expect(isSystemEvent('brume:join')).toBe(true);
    expect(isSystemEvent('brume:ack')).toBe(true);
    expect(isSystemEvent('brume:custom')).toBe(true);
  });

  it('returns false for user events', () => {
    expect(isSystemEvent('message')).toBe(false);
    expect(isSystemEvent('user.joined')).toBe(false);
  });
});

describe('isAllowedClientSystemEvent', () => {
  it('allows join, leave, presence_update, ping', () => {
    expect(isAllowedClientSystemEvent(SystemEvent.Join)).toBe(true);
    expect(isAllowedClientSystemEvent(SystemEvent.Leave)).toBe(true);
    expect(isAllowedClientSystemEvent(SystemEvent.PresenceUpdate)).toBe(true);
    expect(isAllowedClientSystemEvent(SystemEvent.Ping)).toBe(true);
  });

  it('rejects server-only system events', () => {
    expect(isAllowedClientSystemEvent(SystemEvent.Ack)).toBe(false);
    expect(isAllowedClientSystemEvent(SystemEvent.Pong)).toBe(false);
    expect(isAllowedClientSystemEvent(SystemEvent.Error)).toBe(false);
    expect(isAllowedClientSystemEvent(SystemEvent.Connected)).toBe(false);
  });
});

describe('isClientSystemEvent (type guard)', () => {
  it('narrows for client events', () => {
    expect(isClientSystemEvent('brume:join')).toBe(true);
    expect(isClientSystemEvent('brume:ping')).toBe(true);
  });

  it('does not narrow for non-client events', () => {
    expect(isClientSystemEvent('brume:ack')).toBe(false);
    expect(isClientSystemEvent('message')).toBe(false);
  });
});

// ─── Constants ───────────────────────────────────────────────────────────────

describe('constants', () => {
  it('MAX_PAYLOAD_SIZE is 64KB', () => {
    expect(MAX_PAYLOAD_SIZE).toBe(64 * 1024);
  });

  it('MAX_CHANNEL_NAME_LENGTH is 256', () => {
    expect(MAX_CHANNEL_NAME_LENGTH).toBe(256);
  });
});
