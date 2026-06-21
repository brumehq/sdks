namespace Brume.Rest;

public partial interface IApiKeysClient
{
    /// <summary>
    /// Returns a list of API keys for the authenticated project.
    /// </summary>
    WithRawResponseTask<ApiKeyListResponse> ListApiKeysAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Creates a new API key for the authenticated project.
    /// </summary>
    WithRawResponseTask<CreateApiKeyResponse> CreateApiKeyAsync(
        CreateApiKeyRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Revokes an API key for the authenticated project.
    /// </summary>
    WithRawResponseTask<RevokeApiKeyResponse> RevokeApiKeyAsync(
        string id,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
