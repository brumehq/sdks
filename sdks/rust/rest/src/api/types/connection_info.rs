pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct ConnectionInfo {
    pub state: serde_json::Value,
    /// RFC-3339 timestamp of the last presence update.
    #[serde(default)]
    pub updated_at: String,
    #[serde(default)]
    pub user_id: String,
}

impl ConnectionInfo {
    pub fn builder() -> ConnectionInfoBuilder {
        <ConnectionInfoBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ConnectionInfoBuilder {
    state: Option<serde_json::Value>,
    updated_at: Option<String>,
    user_id: Option<String>,
}

impl ConnectionInfoBuilder {
    pub fn state(mut self, value: serde_json::Value) -> Self {
        self.state = Some(value);
        self
    }

    pub fn updated_at(mut self, value: impl Into<String>) -> Self {
        self.updated_at = Some(value.into());
        self
    }

    pub fn user_id(mut self, value: impl Into<String>) -> Self {
        self.user_id = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`ConnectionInfo`].
    /// This method will fail if any of the following fields are not set:
    /// - [`state`](ConnectionInfoBuilder::state)
    /// - [`updated_at`](ConnectionInfoBuilder::updated_at)
    /// - [`user_id`](ConnectionInfoBuilder::user_id)
    pub fn build(self) -> Result<ConnectionInfo, BuildError> {
        Ok(ConnectionInfo {
            state: self
                .state
                .ok_or_else(|| BuildError::missing_field("state"))?,
            updated_at: self
                .updated_at
                .ok_or_else(|| BuildError::missing_field("updated_at"))?,
            user_id: self
                .user_id
                .ok_or_else(|| BuildError::missing_field("user_id"))?,
        })
    }
}
