import Foundation

/// `GET /v1/project` success response.
public struct ProjectResponse: Codable, Hashable, Sendable {
    /// RFC-3339 timestamp of project creation.
    public let createdAt: String
    /// Hex-encoded 16-byte project id.
    public let id: String
    public let maxConnections: Int64
    public let name: String
    public let tier: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        createdAt: String,
        id: String,
        maxConnections: Int64,
        name: String,
        tier: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.createdAt = createdAt
        self.id = id
        self.maxConnections = maxConnections
        self.name = name
        self.tier = tier
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.maxConnections = try container.decode(Int64.self, forKey: .maxConnections)
        self.name = try container.decode(String.self, forKey: .name)
        self.tier = try container.decode(String.self, forKey: .tier)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.createdAt, forKey: .createdAt)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.maxConnections, forKey: .maxConnections)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.tier, forKey: .tier)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case id
        case maxConnections = "max_connections"
        case name
        case tier
    }
}