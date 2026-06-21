pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq)]
pub struct PublishRequest {
    /// Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
    /// Must NOT start with `brume:` (reserved for system events).
    #[serde(default)]
    pub event: String,
    /// Free-form JSON payload delivered to subscribers.
    #[serde(default)]
    pub payload: HashMap<String, serde_json::Value>,
    /// Optional client-generated idempotency key. Echoed in `brume:ack`.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub r#ref: Option<String>,
}

impl PublishRequest {
    pub fn builder() -> PublishRequestBuilder {
        <PublishRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct PublishRequestBuilder {
    event: Option<String>,
    payload: Option<HashMap<String, serde_json::Value>>,
    r#ref: Option<String>,
}

impl PublishRequestBuilder {
    pub fn event(mut self, value: impl Into<String>) -> Self {
        self.event = Some(value.into());
        self
    }

    pub fn payload(mut self, value: HashMap<String, serde_json::Value>) -> Self {
        self.payload = Some(value);
        self
    }

    pub fn r#ref(mut self, value: impl Into<String>) -> Self {
        self.r#ref = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`PublishRequest`].
    /// This method will fail if any of the following fields are not set:
    /// - [`event`](PublishRequestBuilder::event)
    /// - [`payload`](PublishRequestBuilder::payload)
    pub fn build(self) -> Result<PublishRequest, BuildError> {
        Ok(PublishRequest {
            event: self
                .event
                .ok_or_else(|| BuildError::missing_field("event"))?,
            payload: self
                .payload
                .ok_or_else(|| BuildError::missing_field("payload"))?,
            r#ref: self.r#ref,
        })
    }
}
