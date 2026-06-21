namespace Brume.Rest;

public partial interface IChannelsClient
{
    /// <summary>
    /// Returns a list of all channels for the authenticated project.
    /// </summary>
    WithRawResponseTask<ChannelListResponse> ListChannelsAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Returns the current presence roster for a channel.
    /// </summary>
    WithRawResponseTask<PresenceResponse> GetPresenceAsync(
        string channel,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Server-side REST publish endpoint for non-WebSocket backends
    /// (cron jobs, webhooks, queue workers).
    /// </summary>
    WithRawResponseTask<PublishResponse> PublishAsync(
        string channel,
        PublishRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// JWT extraction priority:
    /// 1. `Sec-WebSocket-Protocol: brume.token.&lt;jwt&gt;` (recommended — keeps the
    ///    token out of access logs, browser history, and referer headers).
    /// 2. `?token=&lt;jwt&gt;` query parameter (legacy; emits a deprecation warning).
    ///
    /// If auth fails, returns an HTTP error response without upgrading.
    /// </summary>
    WithRawResponseTask ConnectAsync(
        ConnectRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
