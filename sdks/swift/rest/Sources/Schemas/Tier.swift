import Foundation

/// One of the four public billing tiers. The wire format is the lowercase
/// id from `tiers::TIERS`. New tiers require both a `tiers::TIERS` entry
/// AND an update to this enum's `as_str` list below.
public enum Tier: String, Codable, Hashable, CaseIterable, Sendable {
    case free
    case starter
    case pro
    case business
}