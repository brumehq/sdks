namespace Brume.Rest;

public partial interface IPostgresClient
{
    /// <summary>
    /// Returns the operational state of the Postgres WAL logical
    /// replication slot for the authenticated project. Project API key
    /// auth (any scope). The doctor reads the gateway's in-process cache
    /// — the numbers reflect the gateway that handled the request, not
    /// a globally-consistent cluster view.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`.
    /// </summary>
    WithRawResponseTask<Dictionary<string, object?>> DoctorAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
