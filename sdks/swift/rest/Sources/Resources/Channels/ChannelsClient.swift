import Foundation

public final class ChannelsClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    /// Returns a list of all channels for the authenticated project.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func listChannels(requestOptions: RequestOptions? = nil) async throws -> ChannelListResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/channels",
            requestOptions: requestOptions,
            responseType: ChannelListResponse.self
        )
    }

    /// Returns the current presence roster for a channel.
    ///
    /// - Parameter channel: Channel name. Same rules as publish.
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func getPresence(channel: String, requestOptions: RequestOptions? = nil) async throws -> PresenceResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/channels/\(channel)/presence",
            requestOptions: requestOptions,
            responseType: PresenceResponse.self
        )
    }

    /// Server-side REST publish endpoint for non-WebSocket backends
    /// (cron jobs, webhooks, queue workers).
    ///
    /// - Parameter channel: Channel name. Must contain at least one `:` separator (e.g., `room:123`). 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`.
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func publish(channel: String, request: Requests.PublishRequest, requestOptions: RequestOptions? = nil) async throws -> PublishResponse {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/channels/\(channel)/publish",
            body: request,
            requestOptions: requestOptions,
            responseType: PublishResponse.self
        )
    }

    /// JWT extraction priority:
    /// 1. `Sec-WebSocket-Protocol: brume.token.<jwt>` (recommended — keeps the
    ///    token out of access logs, browser history, and referer headers).
    /// 2. `?token=<jwt>` query parameter (legacy; emits a deprecation warning).
    /// 
    /// If auth fails, returns an HTTP error response without upgrading.
    ///
    /// - Parameter token: Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func connect(token: String? = nil, requestOptions: RequestOptions? = nil) async throws -> Void {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/connect",
            queryParams: [
                "token": token.map { .string($0) }
            ],
            requestOptions: requestOptions
        )
    }
}