import Foundation

public struct WebhookDeliveryItem: Codable, Hashable, Sendable {
    public let attempts: Int
    /// RFC-3339 timestamp of delivery creation.
    public let createdAt: String
    public let eventType: String
    public let id: String
    /// RFC-3339 timestamp of the most recent attempt, or `null`.
    public let lastAttemptAt: String?
    /// HTTP status code of the most recent attempt, or `null`.
    public let responseStatus: Int?
    /// `"pending" | "delivered" | "failed"`.
    public let status: String
    /// Additional properties that are not explicitly defined in the schema
    public let additionalProperties: [String: JSONValue]

    public init(
        attempts: Int,
        createdAt: String,
        eventType: String,
        id: String,
        lastAttemptAt: String? = nil,
        responseStatus: Int? = nil,
        status: String,
        additionalProperties: [String: JSONValue] = .init()
    ) {
        self.attempts = attempts
        self.createdAt = createdAt
        self.eventType = eventType
        self.id = id
        self.lastAttemptAt = lastAttemptAt
        self.responseStatus = responseStatus
        self.status = status
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attempts = try container.decode(Int.self, forKey: .attempts)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.eventType = try container.decode(String.self, forKey: .eventType)
        self.id = try container.decode(String.self, forKey: .id)
        self.lastAttemptAt = try container.decodeIfPresent(String.self, forKey: .lastAttemptAt)
        self.responseStatus = try container.decodeIfPresent(Int.self, forKey: .responseStatus)
        self.status = try container.decode(String.self, forKey: .status)
        self.additionalProperties = try decoder.decodeAdditionalProperties(using: CodingKeys.self)
    }

    public func encode(to encoder: Encoder) throws -> Void {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encodeAdditionalProperties(self.additionalProperties)
        try container.encode(self.attempts, forKey: .attempts)
        try container.encode(self.createdAt, forKey: .createdAt)
        try container.encode(self.eventType, forKey: .eventType)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.lastAttemptAt, forKey: .lastAttemptAt)
        try container.encodeIfPresent(self.responseStatus, forKey: .responseStatus)
        try container.encode(self.status, forKey: .status)
    }

    /// Keys for encoding/decoding struct properties.
    enum CodingKeys: String, CodingKey, CaseIterable {
        case attempts
        case createdAt = "created_at"
        case eventType = "event_type"
        case id
        case lastAttemptAt = "last_attempt_at"
        case responseStatus = "response_status"
        case status
    }
}