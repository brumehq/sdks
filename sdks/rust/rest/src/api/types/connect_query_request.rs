pub use crate::prelude::*;

/// Query parameters for connect
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ConnectQueryRequest {
    /// Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub token: Option<String>,
}

impl ConnectQueryRequest {
    pub fn builder() -> ConnectQueryRequestBuilder {
        <ConnectQueryRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ConnectQueryRequestBuilder {
    token: Option<String>,
}

impl ConnectQueryRequestBuilder {
    pub fn token(mut self, value: impl Into<String>) -> Self {
        self.token = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`ConnectQueryRequest`].
    pub fn build(self) -> Result<ConnectQueryRequest, BuildError> {
        Ok(ConnectQueryRequest { token: self.token })
    }
}
