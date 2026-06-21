import Foundation

public final class LongpollClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    public func longPollChannel(channel: String, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/poll/\(channel)",
            requestOptions: requestOptions
        )
    }
}