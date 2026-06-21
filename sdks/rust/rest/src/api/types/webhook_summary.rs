pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookSummary {
    /// RFC-3339 creation timestamp.
    #[serde(default)]
    pub created_at: String,
    #[serde(default)]
    pub events: Vec<String>,
    #[serde(default)]
    pub id: String,
    #[serde(default)]
    pub url: String,
}

impl WebhookSummary {
    pub fn builder() -> WebhookSummaryBuilder {
        <WebhookSummaryBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookSummaryBuilder {
    created_at: Option<String>,
    events: Option<Vec<String>>,
    id: Option<String>,
    url: Option<String>,
}

impl WebhookSummaryBuilder {
    pub fn created_at(mut self, value: impl Into<String>) -> Self {
        self.created_at = Some(value.into());
        self
    }

    pub fn events(mut self, value: Vec<String>) -> Self {
        self.events = Some(value);
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn url(mut self, value: impl Into<String>) -> Self {
        self.url = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`WebhookSummary`].
    /// This method will fail if any of the following fields are not set:
    /// - [`created_at`](WebhookSummaryBuilder::created_at)
    /// - [`events`](WebhookSummaryBuilder::events)
    /// - [`id`](WebhookSummaryBuilder::id)
    /// - [`url`](WebhookSummaryBuilder::url)
    pub fn build(self) -> Result<WebhookSummary, BuildError> {
        Ok(WebhookSummary {
            created_at: self
                .created_at
                .ok_or_else(|| BuildError::missing_field("created_at"))?,
            events: self
                .events
                .ok_or_else(|| BuildError::missing_field("events"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            url: self.url.ok_or_else(|| BuildError::missing_field("url"))?,
        })
    }
}
