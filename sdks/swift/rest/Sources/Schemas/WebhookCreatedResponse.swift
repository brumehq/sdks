import Foundation

/// `POST /v1/webhooks` success response. Includes the `secret` field
/// which is only returned at creation time.
public struct WebhookCreatedResponse: Codable, Hashable, Sendable {
    public let events: [String]
    public let id: String
    /// HMAC-SHA256 secret used to sign deliveries. Only returned once.
    public let secret: String
    public let url: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        events: [String],
        id: String,
        secret: String,
        url: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.events = events
        self.id = id
        self.secret = secret
        self.url = url
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.events = try container.decode([String].self, forKey: .events)
        self.id = try container.decode(String.self, forKey: .id)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.url = try container.decode(String.self, forKey: .url)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.events, forKey: .events)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.secret, forKey: .secret)
        try container.encode(self.url, forKey: .url)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case events
        case id
        case secret
        case url
    }
}