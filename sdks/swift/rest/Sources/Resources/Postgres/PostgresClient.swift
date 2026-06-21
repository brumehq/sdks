import Foundation

public final class PostgresClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    /// Returns the operational state of the Postgres WAL logical
    /// replication slot for the authenticated project. Project API key
    /// auth (any scope). The doctor reads the gateway's in-process cache
    /// — the numbers reflect the gateway that handled the request, not
    /// a globally-consistent cluster view.
    /// 
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func doctor(requestOptions: RequestOptions? = nil) async throws -> [String: JSONValue] {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/postgres/doctor",
            requestOptions: requestOptions,
            responseType: [String: JSONValue].self
        )
    }
}