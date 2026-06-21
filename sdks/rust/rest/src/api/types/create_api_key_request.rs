pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct CreateApiKeyRequest {
    /// `"live"` or `"test"`. Determines the key prefix
    /// (`pk_live_` vs `pk_test_`) and the default scope set.
    #[serde(default)]
    pub environment: String,
    /// Human-readable label. Shown in the dashboard.
    #[serde(default)]
    pub label: String,
    /// Optional explicit scopes. Omit to receive the default scope set
    /// (`publish`, `read_stats`, `manage_keys`).
    #[serde(skip_serializing_if = "Option::is_none")]
    pub scopes: Option<Vec<ApiKeyScope>>,
}

impl CreateApiKeyRequest {
    pub fn builder() -> CreateApiKeyRequestBuilder {
        <CreateApiKeyRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct CreateApiKeyRequestBuilder {
    environment: Option<String>,
    label: Option<String>,
    scopes: Option<Vec<ApiKeyScope>>,
}

impl CreateApiKeyRequestBuilder {
    pub fn environment(mut self, value: impl Into<String>) -> Self {
        self.environment = Some(value.into());
        self
    }

    pub fn label(mut self, value: impl Into<String>) -> Self {
        self.label = Some(value.into());
        self
    }

    pub fn scopes(mut self, value: Vec<ApiKeyScope>) -> Self {
        self.scopes = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`CreateApiKeyRequest`].
    /// This method will fail if any of the following fields are not set:
    /// - [`environment`](CreateApiKeyRequestBuilder::environment)
    /// - [`label`](CreateApiKeyRequestBuilder::label)
    pub fn build(self) -> Result<CreateApiKeyRequest, BuildError> {
        Ok(CreateApiKeyRequest {
            environment: self
                .environment
                .ok_or_else(|| BuildError::missing_field("environment"))?,
            label: self
                .label
                .ok_or_else(|| BuildError::missing_field("label"))?,
            scopes: self.scopes,
        })
    }
}
