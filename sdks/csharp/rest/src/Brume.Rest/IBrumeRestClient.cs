namespace Brume.Rest;

public partial interface IBrumeRestClient
{
    public IPublicClient Public { get; }
    public IStatsClient Stats { get; }
    public IApiKeysClient ApiKeys { get; }
    public IChannelsClient Channels { get; }
    public ILongpollClient Longpoll { get; }
    public IPostgresClient Postgres { get; }
    public IProjectsClient Projects { get; }
    public ISseClient Sse { get; }
    public IWebhooksClient Webhooks { get; }

    /// <summary>
    /// Returns the full operational picture for a project: counters,
    /// latency percentiles, Postgres lag, top channels, and a plan-limit
    /// snapshot. Project API key auth (any scope). No secrets, no
    /// high-cardinality data, no admin gating.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats` and `/v1/analytics`.
    /// </summary>
    WithRawResponseTask<Dictionary<string, object?>> DiagnosticsAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
