import Foundation

/// Standard error response body returned by all REST endpoints on 4xx/5xx.
/// 
/// The legacy handlers emit `{"error": "..."}` (string-only). The newer
/// handlers emit `{"error": "CODE", "message": "human-readable"}`. Both
/// shapes parse into this struct; the `message` field is optional for
/// back-compat.
public struct ErrorBody: Codable, Hashable, Sendable {
    /// Short error code. Either a stable machine code (`AUTH_INVALID`,
    /// `RATE_LIMITED`, `EMAIL_NOT_VERIFIED`, etc.) or a free-form string
    /// for legacy handlers. SDK consumers should pattern-match the
    /// well-known codes and treat unknown values as opaque failures.
    public let error: String
    /// Human-readable description. Absent on legacy string-only errors.
    public let message: String?
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        error: String,
        message: String? = nil,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.error = error
        self.message = message
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(String.self, forKey: .error)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.error, forKey: .error)
        try container.encodeIfPresent(self.message, forKey: .message)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case error
        case message
    }
}