namespace Brume.Rest;

public partial interface IPublicClient
{
    WithRawResponseTask HealthAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Prometheus-compatible metrics endpoint.
    /// </summary>
    WithRawResponseTask MetricsAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Public (no auth) so SDK-generation tools (Fern, Stainless, etc.) can
    /// fetch the spec without holding a Brume API key. The spec itself only
    /// describes existence of routes; it does not leak auth bypass — every
    /// documented operation still requires the appropriate security
    /// credentials at request time.
    /// </summary>
    WithRawResponseTask OpenapiSpecAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    WithRawResponseTask<ReadyzResponse> ReadyzAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
