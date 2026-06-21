import Foundation

public final class StatsClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    /// Returns the project's analytics history as a list of snapshots
    /// (oldest first). Snapshots are sampled every 30s in-process. The
    /// response includes the last `window / interval` entries. Empty
    /// state is an empty `snapshots` array — never faked data.
    /// 
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`: the shape is pinned by tests.
    ///
    /// - Parameter windowSecs: Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func analytics(windowSecs: Int64? = nil, requestOptions: RequestOptions? = nil) async throws -> [String: JSONValue] {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/analytics",
            queryParams: [
                "window_secs": windowSecs.map { .int64($0) }
            ],
            requestOptions: requestOptions,
            responseType: [String: JSONValue].self
        )
    }

    /// Returns project-level and global connection/channel statistics.
    /// 
    /// Backwards compatibility: existing fields are preserved exactly. New
    /// fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
    /// slow_consumer_disconnections, dead_connections_cleaned,
    /// auth_failures_last_minute, plan_limit_rejections, top_channels) are
    /// additive — older dashboard clients keep working.
    /// 
    /// Response body is documented as `additionalProperties: true` because
    /// the exact JSON shape is pinned by ~10 unit tests in this file. A
    /// future PR can type the envelope; for now SDK consumers will see
    /// `Record<string, any>`.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func getStats(requestOptions: RequestOptions? = nil) async throws -> [String: JSONValue] {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/stats",
            requestOptions: requestOptions,
            responseType: [String: JSONValue].self
        )
    }
}