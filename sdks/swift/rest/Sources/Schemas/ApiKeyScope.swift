import Foundation

/// API key scope (E6). Legacy keys without explicit scopes keep full
/// access; see migration `007_e_workstream.sql`.
public enum ApiKeyScope: String, Codable, Hashable, CaseIterable, Sendable {
    case publish
    case readStats = "read_stats"
    case manageKeys = "manage_keys"
    case manageProject = "manage_project"
}