pub use crate::prelude::*;

/// `GET /v1/webhooks/:id/deliveries` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct WebhookDeliveryListResponse {
    #[serde(default)]
    pub deliveries: Vec<WebhookDeliveryItem>,
}

impl WebhookDeliveryListResponse {
    pub fn builder() -> WebhookDeliveryListResponseBuilder {
        <WebhookDeliveryListResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct WebhookDeliveryListResponseBuilder {
    deliveries: Option<Vec<WebhookDeliveryItem>>,
}

impl WebhookDeliveryListResponseBuilder {
    pub fn deliveries(mut self, value: Vec<WebhookDeliveryItem>) -> Self {
        self.deliveries = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`WebhookDeliveryListResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`deliveries`](WebhookDeliveryListResponseBuilder::deliveries)
    pub fn build(self) -> Result<WebhookDeliveryListResponse, BuildError> {
        Ok(WebhookDeliveryListResponse {
            deliveries: self
                .deliveries
                .ok_or_else(|| BuildError::missing_field("deliveries"))?,
        })
    }
}
