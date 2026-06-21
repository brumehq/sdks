import Foundation

public struct ConnectionInfo: Codable, Hashable, Sendable {
    public let state: JSONValue
    /// RFC-3339 timestamp of the last presence update.
    public let updatedAt: String
    public let userId: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        state: JSONValue,
        updatedAt: String,
        userId: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.state = state
        self.updatedAt = updatedAt
        self.userId = userId
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = try container.decode(JSONValue.self, forKey: .state)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.updatedAt, forKey: .updatedAt)
        try container.encode(self.userId, forKey: .userId)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case state
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
}