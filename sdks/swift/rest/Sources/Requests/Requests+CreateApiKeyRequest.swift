import Foundation

extension Requests {
    public struct CreateApiKeyRequest: Codable, Hashable, Sendable {
        /// `"live"` or `"test"`. Determines the key prefix
        /// (`pk_live_` vs `pk_test_`) and the default scope set.
        public let environment: String
        /// Human-readable label. Shown in the dashboard.
        public let label: String
        /// Optional explicit scopes. Omit to receive the default scope set
        /// (`publish`, `read_stats`, `manage_keys`).
        public let scopes: [ApiKeyScope]?
        /// Additional properties that are not explicitly defined in the schema
        public let additionalProperties: [String: JSONValue]

        public init(
            environment: String,
            label: String,
            scopes: [ApiKeyScope]? = nil,
            additionalProperties: [String: JSONValue] = .init()
        ) {
            self.environment = environment
            self.label = label
            self.scopes = scopes
            self.additionalProperties = additionalProperties
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.environment = try container.decode(String.self, forKey: .environment)
            self.label = try container.decode(String.self, forKey: .label)
            self.scopes = try container.decodeIfPresent([ApiKeyScope].self, forKey: .scopes)
            self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
        }

        public func encode(to encoder: Encoder) throws -> Void {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeAdditionalProperties(self.additionalProperties)
            try container.encode(self.environment, forKey: .environment)
            try container.encode(self.label, forKey: .label)
            try container.encodeIfPresent(self.scopes, forKey: .scopes)
        }

        /// Keys for encoding/decoding struct properties.
        enum CodingKeys: String, CodingKey, CaseIterable {
            case environment
            case label
            case scopes
        }
    }
}