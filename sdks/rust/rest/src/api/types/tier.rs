pub use crate::prelude::*;

/// One of the four public billing tiers. The wire format is the lowercase
/// id from `tiers::TIERS`. New tiers require both a `tiers::TIERS` entry
/// AND an update to this enum's `as_str` list below.
#[non_exhaustive]
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Tier {
    Free,
    Starter,
    Pro,
    Business,
    /// This variant is used for forward compatibility.
    /// If the server sends a value not recognized by the current SDK version,
    /// it will be captured here with the raw string value.
    __Unknown(String),
}
impl Serialize for Tier {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        match self {
            Self::Free => serializer.serialize_str("free"),
            Self::Starter => serializer.serialize_str("starter"),
            Self::Pro => serializer.serialize_str("pro"),
            Self::Business => serializer.serialize_str("business"),
            Self::__Unknown(val) => serializer.serialize_str(val),
        }
    }
}

impl<'de> Deserialize<'de> for Tier {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = String::deserialize(deserializer)?;
        match value.as_str() {
            "free" => Ok(Self::Free),
            "starter" => Ok(Self::Starter),
            "pro" => Ok(Self::Pro),
            "business" => Ok(Self::Business),
            _ => Ok(Self::__Unknown(value)),
        }
    }
}

impl fmt::Display for Tier {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Free => write!(f, "free"),
            Self::Starter => write!(f, "starter"),
            Self::Pro => write!(f, "pro"),
            Self::Business => write!(f, "business"),
            Self::__Unknown(val) => write!(f, "{}", val),
        }
    }
}
