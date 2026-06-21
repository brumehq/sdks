pub use crate::prelude::*;

/// `GET /v1/api-keys` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ApiKeyListResponse {
    #[serde(default)]
    pub api_keys: Vec<ApiKeyListItem>,
}

impl ApiKeyListResponse {
    pub fn builder() -> ApiKeyListResponseBuilder {
        <ApiKeyListResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ApiKeyListResponseBuilder {
    api_keys: Option<Vec<ApiKeyListItem>>,
}

impl ApiKeyListResponseBuilder {
    pub fn api_keys(mut self, value: Vec<ApiKeyListItem>) -> Self {
        self.api_keys = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`ApiKeyListResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`api_keys`](ApiKeyListResponseBuilder::api_keys)
    pub fn build(self) -> Result<ApiKeyListResponse, BuildError> {
        Ok(ApiKeyListResponse {
            api_keys: self
                .api_keys
                .ok_or_else(|| BuildError::missing_field("api_keys"))?,
        })
    }
}
