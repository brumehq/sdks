pub use crate::prelude::*;

/// `POST /v1/channels/:channel/publish` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct PublishResponse {
    #[serde(default)]
    pub channel: String,
    #[serde(default)]
    pub event: String,
    /// Number of subscribers the message was fanned out to.
    #[serde(default)]
    pub recipients: i64,
    /// Always `"published"`. Reserved for future state changes.
    #[serde(default)]
    pub status: String,
}

impl PublishResponse {
    pub fn builder() -> PublishResponseBuilder {
        <PublishResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct PublishResponseBuilder {
    channel: Option<String>,
    event: Option<String>,
    recipients: Option<i64>,
    status: Option<String>,
}

impl PublishResponseBuilder {
    pub fn channel(mut self, value: impl Into<String>) -> Self {
        self.channel = Some(value.into());
        self
    }

    pub fn event(mut self, value: impl Into<String>) -> Self {
        self.event = Some(value.into());
        self
    }

    pub fn recipients(mut self, value: i64) -> Self {
        self.recipients = Some(value);
        self
    }

    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`PublishResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`channel`](PublishResponseBuilder::channel)
    /// - [`event`](PublishResponseBuilder::event)
    /// - [`recipients`](PublishResponseBuilder::recipients)
    /// - [`status`](PublishResponseBuilder::status)
    pub fn build(self) -> Result<PublishResponse, BuildError> {
        Ok(PublishResponse {
            channel: self
                .channel
                .ok_or_else(|| BuildError::missing_field("channel"))?,
            event: self
                .event
                .ok_or_else(|| BuildError::missing_field("event"))?,
            recipients: self
                .recipients
                .ok_or_else(|| BuildError::missing_field("recipients"))?,
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
