pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookDeliveryItem {
    #[serde(default)]
    pub attempts: i64,
    /// RFC-3339 timestamp of delivery creation.
    #[serde(default)]
    pub created_at: String,
    #[serde(default)]
    pub event_type: String,
    #[serde(default)]
    pub id: String,
    /// RFC-3339 timestamp of the most recent attempt, or `null`.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub last_attempt_at: Option<String>,
    /// HTTP status code of the most recent attempt, or `null`.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub response_status: Option<i64>,
    /// `"pending" | "delivered" | "failed"`.
    #[serde(default)]
    pub status: String,
}

impl WebhookDeliveryItem {
    pub fn builder() -> WebhookDeliveryItemBuilder {
        <WebhookDeliveryItemBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookDeliveryItemBuilder {
    attempts: Option<i64>,
    created_at: Option<String>,
    event_type: Option<String>,
    id: Option<String>,
    last_attempt_at: Option<String>,
    response_status: Option<i64>,
    status: Option<String>,
}

impl WebhookDeliveryItemBuilder {
    pub fn attempts(mut self, value: i64) -> Self {
        self.attempts = Some(value);
        self
    }

    pub fn created_at(mut self, value: impl Into<String>) -> Self {
        self.created_at = Some(value.into());
        self
    }

    pub fn event_type(mut self, value: impl Into<String>) -> Self {
        self.event_type = Some(value.into());
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn last_attempt_at(mut self, value: impl Into<String>) -> Self {
        self.last_attempt_at = Some(value.into());
        self
    }

    pub fn response_status(mut self, value: i64) -> Self {
        self.response_status = Some(value);
        self
    }

    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`WebhookDeliveryItem`].
    /// This method will fail if any of the following fields are not set:
    /// - [`attempts`](WebhookDeliveryItemBuilder::attempts)
    /// - [`created_at`](WebhookDeliveryItemBuilder::created_at)
    /// - [`event_type`](WebhookDeliveryItemBuilder::event_type)
    /// - [`id`](WebhookDeliveryItemBuilder::id)
    /// - [`status`](WebhookDeliveryItemBuilder::status)
    pub fn build(self) -> Result<WebhookDeliveryItem, BuildError> {
        Ok(WebhookDeliveryItem {
            attempts: self
                .attempts
                .ok_or_else(|| BuildError::missing_field("attempts"))?,
            created_at: self
                .created_at
                .ok_or_else(|| BuildError::missing_field("created_at"))?,
            event_type: self
                .event_type
                .ok_or_else(|| BuildError::missing_field("event_type"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            last_attempt_at: self.last_attempt_at,
            response_status: self.response_status,
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
