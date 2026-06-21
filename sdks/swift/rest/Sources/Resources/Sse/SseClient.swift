import Foundation

public final class SseClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    public func subscribeSse(channel: String, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/sse/\(channel)",
            requestOptions: requestOptions
        )
    }
}