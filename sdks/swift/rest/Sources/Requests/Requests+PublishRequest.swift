import Foundation

extension Requests {
    public struct PublishRequest: Codable, Hashable, Sendable {
        /// Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
        /// Must NOT start with `brume:` (reserved for system events).
        public let event: String
        /// Free-form JSON payload delivered to subscribers.
        public let payload: [String: JSONValue]
        /// Optional client-generated idempotency key. Echoed in `brume:ack`.
        public let ref: String?
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            event: String,
            payload: [String: JSONValue],
            ref: String? = nil,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.event = event
            self.payload = payload
            self.ref = ref
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.event = try container.decode(String.self, forKey: .event)
            self.payload = try container.decode([String: JSONValue].self, forKey: .payload)
            self.ref = try container.decodeIfPresent(String.self, forKey: .ref)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.event, forKey: .event)
            try container.encode(self.payload, forKey: .payload)
            try container.encodeIfPresent(self.ref, forKey: .ref)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case event
            case payload
            case ref
        }
    }
}