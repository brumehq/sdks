pub use crate::prelude::*;

/// `GET /v1/channels/:channel/presence` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct PresenceResponse {
    #[serde(default)]
    pub channel: String,
    #[serde(default)]
    pub connection_count: i64,
    /// Connection roster. Empty if presence tracking is disabled or the
    /// channel has no subscribers.
    #[serde(default)]
    pub presence: Vec<ConnectionInfo>,
}

impl PresenceResponse {
    pub fn builder() -> PresenceResponseBuilder {
        <PresenceResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct PresenceResponseBuilder {
    channel: Option<String>,
    connection_count: Option<i64>,
    presence: Option<Vec<ConnectionInfo>>,
}

impl PresenceResponseBuilder {
    pub fn channel(mut self, value: impl Into<String>) -> Self {
        self.channel = Some(value.into());
        self
    }

    pub fn connection_count(mut self, value: i64) -> Self {
        self.connection_count = Some(value);
        self
    }

    pub fn presence(mut self, value: Vec<ConnectionInfo>) -> Self {
        self.presence = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`PresenceResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`channel`](PresenceResponseBuilder::channel)
    /// - [`connection_count`](PresenceResponseBuilder::connection_count)
    /// - [`presence`](PresenceResponseBuilder::presence)
    pub fn build(self) -> Result<PresenceResponse, BuildError> {
        Ok(PresenceResponse {
            channel: self
                .channel
                .ok_or_else(|| BuildError::missing_field("channel"))?,
            connection_count: self
                .connection_count
                .ok_or_else(|| BuildError::missing_field("connection_count"))?,
            presence: self
                .presence
                .ok_or_else(|| BuildError::missing_field("presence"))?,
        })
    }
}
