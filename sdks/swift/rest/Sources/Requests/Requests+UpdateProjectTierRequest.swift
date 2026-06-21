import Foundation

extension Requests {
    public struct UpdateProjectTierRequest: Codable, Hashable, Sendable {
        /// One of `"free" | "starter" | "pro" | "business"`.
        public let tier: String
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            tier: String,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.tier = tier
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.tier = try container.decode(String.self, forKey: .tier)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.tier, forKey: .tier)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case tier
        }
    }
}