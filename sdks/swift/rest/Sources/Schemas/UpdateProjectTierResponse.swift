import Foundation

/// `PATCH /v1/projects/:id/tier` success response.
public struct UpdateProjectTierResponse: Codable, Hashable, Sendable {
    /// Echo of the path param (hex-encoded project id).
    public let id: String
    public let maxConnections: Int64
    public let tier: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        id: String,
        maxConnections: Int64,
        tier: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.id = id
        self.maxConnections = maxConnections
        self.tier = tier
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.maxConnections = try container.decode(Int64.self, forKey: .maxConnections)
        self.tier = try container.decode(String.self, forKey: .tier)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.maxConnections, forKey: .maxConnections)
        try container.encode(self.tier, forKey: .tier)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case maxConnections = "max_connections"
        case tier
    }
}