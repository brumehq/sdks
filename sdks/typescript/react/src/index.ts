'use client';

import { createClient } from '@brume/client';
import type { BrumeOptions } from '@brume/client';
import { useCallback, useEffect, useRef, useState } from 'react';

export type ChannelStatus = 'connecting' | 'connected' | 'reconnecting' | 'disconnected' | 'failed';

// ─── useChannel ────────────────────────────────────────────────────────────

export function useChannel<Events extends Record<string, unknown> = Record<string, unknown>>(
  options: BrumeOptions & { channelName: string },
) {
  const clientRef = useRef<ReturnType<typeof createClient> | null>(null);
  const [connected, setConnected] = useState(false);
  const [status, setStatus] = useState<ChannelStatus>('connecting');
  const [error, setError] = useState<Error | null>(null);
  const mountedRef = useRef(true);

  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
    };
  }, []);

  useEffect(() => {
    const client = createClient({
      url: options.url,
      token: options.token,
      ackTimeoutMs: options.ackTimeoutMs,
      maxReconnectAttempts: options.maxReconnectAttempts,
      onConnectionStateChange: (state: string) => {
        if (!mountedRef.current) 
return;
        setStatus(state as ChannelStatus);
        if (state === 'connected') 
setConnected(true);
        if (state === 'disconnected' || state === 'reconnecting') 
setConnected(false);
      },
    });
    clientRef.current = client;
    const channel = client.channel<Events>(options.channelName);

    channel
      .join()
      .then(() => {
        if (!mountedRef.current) 
return;
        setConnected(true);
        setStatus('connected');
        setError(null);
      })
      .catch((err: unknown) => {
        if (!mountedRef.current) 
return;
        setStatus('failed');
        setError(err instanceof Error ? err : new Error(String(err)));
      });

    return () => {
      channel.leave();
      client.disconnect();
    };
  }, [
    options.url,
    options.channelName,
    options.token,
    options.ackTimeoutMs,
    options.maxReconnectAttempts,
  ]);

  const send = useCallback(
    <E extends keyof Events & string>(event: E, payload: Events[E]) => {
      const ch = clientRef.current?.channel<Events>(options.channelName);
      if (!ch) 
return Promise.reject(new Error('Channel not ready'));
      return ch.send(event, payload);
    },
    [options.channelName],
  );

  const on = useCallback(
    <E extends keyof Events & string>(
      event: E,
      handler: () => void,
    ): (() => void) => {
      const ch = clientRef.current?.channel<Events>(options.channelName);
      if (!ch) 
return () => {};
      ch.on(event, handler);
      return () => ch.off(event, handler);
    },
    [options.channelName],
  );

  return { connected, status, error, send, on };
}

// ─── usePresence ────────────────────────────────────────────────────────────

interface PresenceEntry {
  connectionId: string;
  state: Record<string, unknown>;
  updatedAt: number;
}

interface PresenceSnapshot {
  type?: string;
  connection_id?: string;
  state?: Record<string, unknown>;
}

interface PresenceRestResponse {
  channel: string;
  connection_count: number;
  presence?: {
    users: Array<{
      user_id: string;
      state: Record<string, unknown>;
      updated_at: number;
    }>;
  };
}

export interface UsePresenceOptions extends BrumeOptions {
  channelName: string;
  /**
   * Server-side API key for fetching the initial presence roster via REST.
   * If not provided, the roster starts empty and populates only via
   * real-time presence events.
   */
  serverApiKey?: string;
}

export function usePresence(options: UsePresenceOptions) {
  const clientRef = useRef<ReturnType<typeof createClient> | null>(null);
  const cleanupRef = useRef<(() => void) | null>(null);
  const [roster, setRoster] = useState<PresenceEntry[]>([]);
  const [count, setCount] = useState(0);
  const mountedRef = useRef(true);

  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
    };
  }, []);

  useEffect(() => {
    const client = createClient(options);
    clientRef.current = client;
    const channel = client.channel(options.channelName);

    // Fetch initial presence roster via REST if API key provided
    if (options.serverApiKey) {
      const baseUrl = options.url.replace(/\/+$/, '');
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10000);

      fetch(`${baseUrl}/v1/channels/${encodeURIComponent(options.channelName)}/presence`, {
        headers: { Authorization: `Bearer ${options.serverApiKey}` },
        signal: controller.signal,
      })
        .then((res) => (res.ok ? res.json() : null))
        .then((data: PresenceRestResponse | null) => {
          clearTimeout(timeoutId);
          if (!mountedRef.current) 
return;
          if (data?.presence?.users) {
            setRoster(
              data.presence.users.map((u) => ({
                connectionId: u.user_id,
                state: u.state,
                updatedAt: u.updated_at,
              })),
            );
            setCount(data.connection_count);
          }
        })
        .catch(() => {
          clearTimeout(timeoutId);
          // Non-fatal — roster will populate via real-time events
        });
    }

    channel.join().catch(() => {
      // join error handled by useChannel pattern if needed
    });

    // Subscribe to real-time presence updates
    const unsubscribe = channel.onPresence((payload: unknown) => {
      const snap = payload as PresenceSnapshot | undefined;
      if (!snap) 
return;
      if (snap.type === 'join' && snap.connection_id) {
        if (!mountedRef.current) 
return;
        setRoster((prev) => [
          ...prev.filter((u) => u.connectionId !== snap.connection_id),
          {
            connectionId: snap.connection_id!,
            state: snap.state ?? {},
            updatedAt: Math.floor(Date.now() / 1000),
          },
        ]);
        setCount((c) => c + 1);
      } else if (snap.type === 'leave' && snap.connection_id) {
        if (!mountedRef.current) 
return;
        setRoster((prev) => prev.filter((u) => u.connectionId !== snap.connection_id));
        setCount((c) => Math.max(0, c - 1));
      }
    });

    cleanupRef.current = () => {
      unsubscribe();
      channel.leave();
      client.disconnect();
    };

    return () => {
      cleanupRef.current?.();
      cleanupRef.current = null;
    };
  }, [
    options.url,
    options.channelName,
    options.token,
    options.ackTimeoutMs,
    options.maxReconnectAttempts,
    options.serverApiKey,
  ]);

  const track = useCallback(
    (state: Record<string, unknown>) => {
      const ch = clientRef.current?.channel(options.channelName);
      ch?.track(state);
    },
    [options.channelName],
  );

  return { roster, count, track };
}
