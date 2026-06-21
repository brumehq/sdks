import Foundation

/// `GET /v1/channels/:channel/presence` success response.
public struct PresenceResponse: Codable, Hashable, Sendable {
    public let channel: String
    public let connectionCount: Int
    /// Connection roster. Empty if presence tracking is disabled or the
    /// channel has no subscribers.
    public let presence: [ConnectionInfo]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        channel: String,
        connectionCount: Int,
        presence: [ConnectionInfo],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.channel = channel
        self.connectionCount = connectionCount
        self.presence = presence
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.connectionCount = try container.decode(Int.self, forKey: .connectionCount)
        self.presence = try container.decode([ConnectionInfo].self, forKey: .presence)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.channel, forKey: .channel)
        try container.encode(self.connectionCount, forKey: .connectionCount)
        try container.encode(self.presence, forKey: .presence)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case channel
        case connectionCount = "connection_count"
        case presence
    }
}