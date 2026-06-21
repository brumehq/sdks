import { describe, expect, it } from 'vitest';

import { useChannel, usePresence } from './index';

describe('useChannel', () => {
  it('is a function', () => {
    expect(typeof useChannel).toBe('function');
  });
});

describe('usePresence', () => {
  it('is a function', () => {
    expect(typeof usePresence).toBe('function');
  });
});
