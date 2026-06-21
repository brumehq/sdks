pub use crate::prelude::*;

/// `GET /v1/webhooks` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookListResponse {
    #[serde(default)]
    pub webhooks: Vec<WebhookSummary>,
}

impl WebhookListResponse {
    pub fn builder() -> WebhookListResponseBuilder {
        <WebhookListResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookListResponseBuilder {
    webhooks: Option<Vec<WebhookSummary>>,
}

impl WebhookListResponseBuilder {
    pub fn webhooks(mut self, value: Vec<WebhookSummary>) -> Self {
        self.webhooks = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`WebhookListResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`webhooks`](WebhookListResponseBuilder::webhooks)
    pub fn build(self) -> Result<WebhookListResponse, BuildError> {
        Ok(WebhookListResponse {
            webhooks: self
                .webhooks
                .ok_or_else(|| BuildError::missing_field("webhooks"))?,
        })
    }
}
