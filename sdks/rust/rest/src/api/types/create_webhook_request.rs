pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct CreateWebhookRequest {
    /// Event names to subscribe to (e.g. `["channel.message.published"]`).
    #[serde(default)]
    pub events: Vec<String>,
    /// Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    #[serde(default)]
    pub url: String,
}

impl CreateWebhookRequest {
    pub fn builder() -> CreateWebhookRequestBuilder {
        <CreateWebhookRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct CreateWebhookRequestBuilder {
    events: Option<Vec<String>>,
    url: Option<String>,
}

impl CreateWebhookRequestBuilder {
    pub fn events(mut self, value: Vec<String>) -> Self {
        self.events = Some(value);
        self
    }

    pub fn url(mut self, value: impl Into<String>) -> Self {
        self.url = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`CreateWebhookRequest`].
    /// This method will fail if any of the following fields are not set:
    /// - [`events`](CreateWebhookRequestBuilder::events)
    /// - [`url`](CreateWebhookRequestBuilder::url)
    pub fn build(self) -> Result<CreateWebhookRequest, BuildError> {
        Ok(CreateWebhookRequest {
            events: self
                .events
                .ok_or_else(|| BuildError::missing_field("events"))?,
            url: self.url.ok_or_else(|| BuildError::missing_field("url"))?,
        })
    }
}
