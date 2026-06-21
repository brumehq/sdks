pub use crate::prelude::*;

/// `DELETE /v1/webhooks/:id` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookDeleteResponse {
    /// Always `"deleted"`.
    #[serde(default)]
    pub status: String,
}

impl WebhookDeleteResponse {
    pub fn builder() -> WebhookDeleteResponseBuilder {
        <WebhookDeleteResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookDeleteResponseBuilder {
    status: Option<String>,
}

impl WebhookDeleteResponseBuilder {
    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`WebhookDeleteResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`status`](WebhookDeleteResponseBuilder::status)
    pub fn build(self) -> Result<WebhookDeleteResponse, BuildError> {
        Ok(WebhookDeleteResponse {
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
