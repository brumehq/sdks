import Foundation

/// `GET /v1/channels` success response.
public struct ChannelListResponse: Codable, Hashable, Sendable {
    public let channels: [ChannelSummary]
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        channels: [ChannelSummary],
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.channels = channels
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channels = try container.decode([ChannelSummary].self, forKey: .channels)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.channels, forKey: .channels)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case channels
    }
}