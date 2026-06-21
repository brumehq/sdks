pub use crate::prelude::*;

/// `GET /readyz` failure body (HTTP 503).
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct NotReadyResponse {
    /// One of: `"db pool closed"`, `"db query failed"`, `"db query timeout"`.
    #[serde(default)]
    pub reason: String,
    #[serde(default)]
    pub status: String,
}

impl NotReadyResponse {
    pub fn builder() -> NotReadyResponseBuilder {
        <NotReadyResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct NotReadyResponseBuilder {
    reason: Option<String>,
    status: Option<String>,
}

impl NotReadyResponseBuilder {
    pub fn reason(mut self, value: impl Into<String>) -> Self {
        self.reason = Some(value.into());
        self
    }

    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`NotReadyResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`reason`](NotReadyResponseBuilder::reason)
    /// - [`status`](NotReadyResponseBuilder::status)
    pub fn build(self) -> Result<NotReadyResponse, BuildError> {
        Ok(NotReadyResponse {
            reason: self
                .reason
                .ok_or_else(|| BuildError::missing_field("reason"))?,
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
