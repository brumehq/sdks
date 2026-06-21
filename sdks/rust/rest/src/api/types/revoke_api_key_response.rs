pub use crate::prelude::*;

/// `DELETE /v1/api-keys/:id` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct RevokeApiKeyResponse {
    /// Always `"revoked"`.
    #[serde(default)]
    pub status: String,
}

impl RevokeApiKeyResponse {
    pub fn builder() -> RevokeApiKeyResponseBuilder {
        <RevokeApiKeyResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct RevokeApiKeyResponseBuilder {
    status: Option<String>,
}

impl RevokeApiKeyResponseBuilder {
    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`RevokeApiKeyResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`status`](RevokeApiKeyResponseBuilder::status)
    pub fn build(self) -> Result<RevokeApiKeyResponse, BuildError> {
        Ok(RevokeApiKeyResponse {
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
