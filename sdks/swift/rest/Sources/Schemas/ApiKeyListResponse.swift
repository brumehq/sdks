import Foundation

/// `GET /v1/api-keys` success response.
public struct ApiKeyListResponse: Codable, Hashable, Sendable {
    public let apiKeys: [ApiKeyListItem]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        apiKeys: [ApiKeyListItem],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.apiKeys = apiKeys
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.apiKeys = try container.decode([ApiKeyListItem].self, forKey: .apiKeys)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.apiKeys, forKey: .apiKeys)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case apiKeys = "api_keys"
    }
}