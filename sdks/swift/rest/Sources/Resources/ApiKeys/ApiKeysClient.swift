import Foundation

public final class ApiKeysClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    /// Returns a list of API keys for the authenticated project.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func listApiKeys(requestOptions: RequestOptions? = nil) async throws -> ApiKeyListResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/api-keys",
            requestOptions: requestOptions,
            responseType: ApiKeyListResponse.self
        )
    }

    /// Creates a new API key for the authenticated project.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func createApiKey(request: Requests.CreateApiKeyRequest, requestOptions: RequestOptions? = nil) async throws -> CreateApiKeyResponse {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/api-keys",
            body: request,
            requestOptions: requestOptions,
            responseType: CreateApiKeyResponse.self
        )
    }

    /// Revokes an API key for the authenticated project.
    ///
    /// - Parameter id: Hex-encoded API key id (16 bytes → 32 hex chars).
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func revokeApiKey(id: String, requestOptions: RequestOptions? = nil) async throws -> RevokeApiKeyResponse {
        return try await httpClient.performRequest(
            method: .delete,
            path: "/v1/api-keys/\(id)",
            requestOptions: requestOptions,
            responseType: RevokeApiKeyResponse.self
        )
    }
}