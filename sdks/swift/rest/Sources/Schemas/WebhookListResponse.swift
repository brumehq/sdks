import Foundation

/// `GET /v1/webhooks` success response.
public struct WebhookListResponse: Codable, Hashable, Sendable {
    public let webhooks: [WebhookSummary]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        webhooks: [WebhookSummary],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.webhooks = webhooks
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.webhooks = try container.decode([WebhookSummary].self, forKey: .webhooks)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.webhooks, forKey: .webhooks)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case webhooks
    }
}