pub use crate::prelude::*;

/// `POST /v1/webhooks` success response. Includes the `secret` field
/// which is only returned at creation time.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookCreatedResponse {
    #[serde(default)]
    pub events: Vec<String>,
    #[serde(default)]
    pub id: String,
    /// HMAC-SHA256 secret used to sign deliveries. Only returned once.
    #[serde(default)]
    pub secret: String,
    #[serde(default)]
    pub url: String,
}

impl WebhookCreatedResponse {
    pub fn builder() -> WebhookCreatedResponseBuilder {
        <WebhookCreatedResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookCreatedResponseBuilder {
    events: Option<Vec<String>>,
    id: Option<String>,
    secret: Option<String>,
    url: Option<String>,
}

impl WebhookCreatedResponseBuilder {
    pub fn events(mut self, value: Vec<String>) -> Self {
        self.events = Some(value);
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn secret(mut self, value: impl Into<String>) -> Self {
        self.secret = Some(value.into());
        self
    }

    pub fn url(mut self, value: impl Into<String>) -> Self {
        self.url = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`WebhookCreatedResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`events`](WebhookCreatedResponseBuilder::events)
    /// - [`id`](WebhookCreatedResponseBuilder::id)
    /// - [`secret`](WebhookCreatedResponseBuilder::secret)
    /// - [`url`](WebhookCreatedResponseBuilder::url)
    pub fn build(self) -> Result<WebhookCreatedResponse, BuildError> {
        Ok(WebhookCreatedResponse {
            events: self
                .events
                .ok_or_else(|| BuildError::missing_field("events"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            secret: self
                .secret
                .ok_or_else(|| BuildError::missing_field("secret"))?,
            url: self.url.ok_or_else(|| BuildError::missing_field("url"))?,
        })
    }
}
