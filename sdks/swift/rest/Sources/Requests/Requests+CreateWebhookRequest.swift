import Foundation

extension Requests {
    public struct CreateWebhookRequest: Codable, Hashable, Sendable {
        /// Event names to subscribe to (e.g. `["channel.message.published"]`).
        public let events: [String]
        /// Destination URL. Validated by `webhook_validation::validate_webhook_url`.
        public let url: String
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            events: [String],
            url: String,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.events = events
            self.url = url
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.events = try container.decode([String].self, forKey: .events)
            self.url = try container.decode(String.self, forKey: .url)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.events, forKey: .events)
            try container.encode(self.url, forKey: .url)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case events
            case url
        }
    }
}