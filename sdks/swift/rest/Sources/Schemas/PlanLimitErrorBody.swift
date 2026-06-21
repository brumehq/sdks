import Foundation

/// `PLAN_LIMIT` error body. Emitted by the publish / create-project /
/// create-key / SSE / long-poll paths when the project hits a per-axis
/// cap. The `code` is always `"PLAN_LIMIT"`; the `reason` is a closed
/// enum string SDK consumers can pattern-match on.
public struct PlanLimitErrorBody: Codable, Hashable, Sendable {
    /// Always `"PLAN_LIMIT"`.
    public let code: String
    /// Current count for the axis that triggered the limit.
    public let current: Int
    /// The cap value, or `null` for unlimited (e.g. business tier
    /// connection cap).
    public let limit: Int?
    /// Human-readable message. Includes the current/limit numbers
    /// and the upgrade suggestion.
    public let message: String
    /// The closed-set reason. See `PlanLimitReason` in
    /// `channels/types.rs` for the full list.
    public let reason: String
    /// The next tier up the ladder that lifts this axis, or `null`
    /// when the customer is already on business.
    public let upgradeTier: String?
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        code: String,
        current: Int,
        limit: Int? = nil,
        message: String,
        reason: String,
        upgradeTier: String? = nil,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.code = code
        self.current = current
        self.limit = limit
        self.message = message
        self.reason = reason
        self.upgradeTier = upgradeTier
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.current = try container.decode(Int.self, forKey: .current)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.message = try container.decode(String.self, forKey: .message)
        self.reason = try container.decode(String.self, forKey: .reason)
        self.upgradeTier = try container.decodeIfPresent(String.self, forKey: .upgradeTier)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.current, forKey: .current)
        try container.encodeIfPresent(self.limit, forKey: .limit)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.reason, forKey: .reason)
        try container.encodeIfPresent(self.upgradeTier, forKey: .upgradeTier)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case code
        case current
        case limit
        case message
        case reason
        case upgradeTier
    }
}