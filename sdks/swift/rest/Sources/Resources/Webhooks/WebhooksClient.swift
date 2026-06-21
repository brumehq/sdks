import Foundation

public final class WebhooksClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    public func list(requestOptions: RequestOptions? = nil) async throws -> WebhookListResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/webhooks",
            requestOptions: requestOptions,
            responseType: WebhookListResponse.self
        )
    }

    public func create(request: Requests.CreateWebhookRequest, requestOptions: RequestOptions? = nil) async throws -> WebhookCreatedResponse {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/webhooks",
            body: request,
            requestOptions: requestOptions,
            responseType: WebhookCreatedResponse.self
        )
    }

    public func delete(id: String, requestOptions: RequestOptions? = nil) async throws -> WebhookDeleteResponse {
        return try await httpClient.performRequest(
            method: .delete,
            path: "/v1/webhooks/\(id)",
            requestOptions: requestOptions,
            responseType: WebhookDeleteResponse.self
        )
    }

    public func listDeliveries(id: String, requestOptions: RequestOptions? = nil) async throws -> WebhookDeliveryListResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/webhooks/\(id)/deliveries",
            requestOptions: requestOptions,
            responseType: WebhookDeliveryListResponse.self
        )
    }

    public func test(id: String, requestOptions: RequestOptions? = nil) async throws -> WebhookTestResponse {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/webhooks/\(id)/test",
            requestOptions: requestOptions,
            responseType: WebhookTestResponse.self
        )
    }
}