pub use crate::prelude::*;

/// API key scope (E6). Legacy keys without explicit scopes keep full
/// access; see migration `007_e_workstream.sql`.
#[non_exhaustive]
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum ApiKeyScope {
    Publish,
    ReadStats,
    ManageKeys,
    ManageProject,
    /// This variant is used for forward compatibility.
    /// If the server sends a value not recognized by the current SDK version,
    /// it will be captured here with the raw string value.
    __Unknown(String),
}
impl Serialize for ApiKeyScope {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        match self {
            Self::Publish => serializer.serialize_str("publish"),
            Self::ReadStats => serializer.serialize_str("read_stats"),
            Self::ManageKeys => serializer.serialize_str("manage_keys"),
            Self::ManageProject => serializer.serialize_str("manage_project"),
            Self::__Unknown(val) => serializer.serialize_str(val),
        }
    }
}

impl<'de> Deserialize<'de> for ApiKeyScope {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = String::deserialize(deserializer)?;
        match value.as_str() {
            "publish" => Ok(Self::Publish),
            "read_stats" => Ok(Self::ReadStats),
            "manage_keys" => Ok(Self::ManageKeys),
            "manage_project" => Ok(Self::ManageProject),
            _ => Ok(Self::__Unknown(value)),
        }
    }
}

impl fmt::Display for ApiKeyScope {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Publish => write!(f, "publish"),
            Self::ReadStats => write!(f, "read_stats"),
            Self::ManageKeys => write!(f, "manage_keys"),
            Self::ManageProject => write!(f, "manage_project"),
            Self::__Unknown(val) => write!(f, "{}", val),
        }
    }
}
