namespace Brume.Rest;

public partial interface IStatsClient
{
    /// <summary>
    /// Returns the project's analytics history as a list of snapshots
    /// (oldest first). Snapshots are sampled every 30s in-process. The
    /// response includes the last `window / interval` entries. Empty
    /// state is an empty `snapshots` array — never faked data.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`: the shape is pinned by tests.
    /// </summary>
    WithRawResponseTask<Dictionary<string, object?>> AnalyticsAsync(
        AnalyticsRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Returns project-level and global connection/channel statistics.
    ///
    /// Backwards compatibility: existing fields are preserved exactly. New
    /// fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
    /// slow_consumer_disconnections, dead_connections_cleaned,
    /// auth_failures_last_minute, plan_limit_rejections, top_channels) are
    /// additive — older dashboard clients keep working.
    ///
    /// Response body is documented as `additionalProperties: true` because
    /// the exact JSON shape is pinned by ~10 unit tests in this file. A
    /// future PR can type the envelope; for now SDK consumers will see
    /// `Record&lt;string, any&gt;`.
    /// </summary>
    WithRawResponseTask<Dictionary<string, object?>> GetStatsAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
