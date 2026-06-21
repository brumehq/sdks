pub use crate::prelude::*;

/// `POST /v1/webhooks/:id/test` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookTestResponse {
    /// Always `"queued"`. The actual delivery runs asynchronously.
    #[serde(default)]
    pub status: String,
}

impl WebhookTestResponse {
    pub fn builder() -> WebhookTestResponseBuilder {
        <WebhookTestResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookTestResponseBuilder {
    status: Option<String>,
}

impl WebhookTestResponseBuilder {
    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`WebhookTestResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`status`](WebhookTestResponseBuilder::status)
    pub fn build(self) -> Result<WebhookTestResponse, BuildError> {
        Ok(WebhookTestResponse {
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
