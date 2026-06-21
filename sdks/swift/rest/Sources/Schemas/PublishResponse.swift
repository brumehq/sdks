import Foundation

/// `POST /v1/channels/:channel/publish` success response.
public struct PublishResponse: Codable, Hashable, Sendable {
    public let channel: String
    public let event: String
    /// Number of subscribers the message was fanned out to.
    public let recipients: Int
    /// Always `"published"`. Reserved for future state changes.
    public let status: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        channel: String,
        event: String,
        recipients: Int,
        status: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.channel = channel
        self.event = event
        self.recipients = recipients
        self.status = status
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.event = try container.decode(String.self, forKey: .event)
        self.recipients = try container.decode(Int.self, forKey: .recipients)
        self.status = try container.decode(String.self, forKey: .status)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.channel, forKey: .channel)
        try container.encode(self.event, forKey: .event)
        try container.encode(self.recipients, forKey: .recipients)
        try container.encode(self.status, forKey: .status)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case channel
        case event
        case recipients
        case status
    }
}