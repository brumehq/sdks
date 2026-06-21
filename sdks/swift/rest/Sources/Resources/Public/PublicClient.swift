import Foundation

public final class PublicClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    public func health(requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .get,
            path: "/health",
            requestOptions: requestOptions
        )
    }

    /// Prometheus-compatible metrics endpoint.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func metrics(requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .get,
            path: "/metrics",
            requestOptions: requestOptions
        )
    }

    /// Public (no auth) so SDK-generation tools (Fern, Stainless, etc.) can
    /// fetch the spec without holding a Brume API key. The spec itself only
    /// describes existence of routes; it does not leak auth bypass — every
    /// documented operation still requires the appropriate security
    /// credentials at request time.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func openapiSpec(requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .get,
            path: "/openapi.json",
            requestOptions: requestOptions
        )
    }

    public func readyz(requestOptions: RequestOptions? = nil) async throws -> ReadyzResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/readyz",
            requestOptions: requestOptions,
            responseType: ReadyzResponse.self
        )
    }
}