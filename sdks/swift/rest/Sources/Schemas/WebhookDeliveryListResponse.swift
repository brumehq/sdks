import Foundation

/// `GET /v1/webhooks/:id/deliveries` success response.
public struct WebhookDeliveryListResponse: Codable, Hashable, Sendable {
    public let deliveries: [WebhookDeliveryItem]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        deliveries: [WebhookDeliveryItem],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.deliveries = deliveries
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deliveries = try container.decode([WebhookDeliveryItem].self, forKey: .deliveries)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.deliveries, forKey: .deliveries)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case deliveries
    }
}