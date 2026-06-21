import Foundation

/// `POST /v1/api-keys` success response. The `key` field is the raw
/// key returned exactly once; clients must store it before navigating
/// away.
public struct CreateApiKeyResponse: Codable, Hashable, Sendable {
    public let environment: String
    /// Hex-encoded key id.
    public let id: String
    /// The raw API key. Only returned by the create endpoint.
    public let key: String
    public let label: String
    /// 28-char prefix used for O(1) lookup. Safe to display.
    public let prefix: String
    /// Granted scopes (E6). Serializes as the snake_case string form
    /// (`"publish"`, `"read_stats"`, `"manage_keys"`, `"manage_project"`).
    public let scopes: [ApiKeyScope]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        environment: String,
        id: String,
        key: String,
        label: String,
        prefix: String,
        scopes: [ApiKeyScope],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.environment = environment
        self.id = id
        self.key = key
        self.label = label
        self.prefix = prefix
        self.scopes = scopes
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.environment = try container.decode(String.self, forKey: .environment)
        self.id = try container.decode(String.self, forKey: .id)
        self.key = try container.decode(String.self, forKey: .key)
        self.label = try container.decode(String.self, forKey: .label)
        self.prefix = try container.decode(String.self, forKey: .prefix)
        self.scopes = try container.decode([ApiKeyScope].self, forKey: .scopes)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.environment, forKey: .environment)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.key, forKey: .key)
        try container.encode(self.label, forKey: .label)
        try container.encode(self.prefix, forKey: .prefix)
        try container.encode(self.scopes, forKey: .scopes)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case environment
        case id
        case key
        case label
        case prefix
        case scopes
    }
}