import Foundation

/// `GET /readyz` failure body (HTTP 503).
public struct NotReadyResponse: Codable, Hashable, Sendable {
    /// One of: `"db pool closed"`, `"db query failed"`, `"db query timeout"`.
    public let reason: String
    public let status: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        reason: String,
        status: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.reason = reason
        self.status = status
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reason = try container.decode(String.self, forKey: .reason)
        self.status = try container.decode(String.self, forKey: .status)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.reason, forKey: .reason)
        try container.encode(self.status, forKey: .status)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
        case status
    }
}