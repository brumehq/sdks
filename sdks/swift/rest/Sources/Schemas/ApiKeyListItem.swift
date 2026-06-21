import Foundation

public struct ApiKeyListItem: Codable, Hashable, Sendable {
    public let environment: String
    public let id: String
    public let label: String
    /// RFC-3339 timestamp of last use, or `null` if never used.
    public let lastUsedAt: String?
    public let prefix: String
    /// Granted scopes (E6). Serializes as snake_case strings.
    public let scopes: [ApiKeyScope]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        environment: String,
        id: String,
        label: String,
        lastUsedAt: String? = nil,
        prefix: String,
        scopes: [ApiKeyScope],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.environment = environment
        self.id = id
        self.label = label
        self.lastUsedAt = lastUsedAt
        self.prefix = prefix
        self.scopes = scopes
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.environment = try container.decode(String.self, forKey: .environment)
        self.id = try container.decode(String.self, forKey: .id)
        self.label = try container.decode(String.self, forKey: .label)
        self.lastUsedAt = try container.decodeIfPresent(String.self, forKey: .lastUsedAt)
        self.prefix = try container.decode(String.self, forKey: .prefix)
        self.scopes = try container.decode([ApiKeyScope].self, forKey: .scopes)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.environment, forKey: .environment)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.label, forKey: .label)
        try container.encodeIfPresent(self.lastUsedAt, forKey: .lastUsedAt)
        try container.encode(self.prefix, forKey: .prefix)
        try container.encode(self.scopes, forKey: .scopes)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case environment
        case id
        case label
        case lastUsedAt = "last_used_at"
        case prefix
        case scopes
    }
}