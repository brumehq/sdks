pub use crate::prelude::*;

/// `POST /v1/api-keys` success response. The `key` field is the raw
/// key returned exactly once; clients must store it before navigating
/// away.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct CreateApiKeyResponse {
    #[serde(default)]
    pub environment: String,
    /// Hex-encoded key id.
    #[serde(default)]
    pub id: String,
    /// The raw API key. Only returned by the create endpoint.
    #[serde(default)]
    pub key: String,
    #[serde(default)]
    pub label: String,
    /// 28-char prefix used for O(1) lookup. Safe to display.
    #[serde(default)]
    pub prefix: String,
    /// Granted scopes (E6). Serializes as the snake_case string form
    /// (`"publish"`, `"read_stats"`, `"manage_keys"`, `"manage_project"`).
    #[serde(default)]
    pub scopes: Vec<ApiKeyScope>,
}

impl CreateApiKeyResponse {
    pub fn builder() -> CreateApiKeyResponseBuilder {
        <CreateApiKeyResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct CreateApiKeyResponseBuilder {
    environment: Option<String>,
    id: Option<String>,
    key: Option<String>,
    label: Option<String>,
    prefix: Option<String>,
    scopes: Option<Vec<ApiKeyScope>>,
}

impl CreateApiKeyResponseBuilder {
    pub fn environment(mut self, value: impl Into<String>) -> Self {
        self.environment = Some(value.into());
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn key(mut self, value: impl Into<String>) -> Self {
        self.key = Some(value.into());
        self
    }

    pub fn label(mut self, value: impl Into<String>) -> Self {
        self.label = Some(value.into());
        self
    }

    pub fn prefix(mut self, value: impl Into<String>) -> Self {
        self.prefix = Some(value.into());
        self
    }

    pub fn scopes(mut self, value: Vec<ApiKeyScope>) -> Self {
        self.scopes = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`CreateApiKeyResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`environment`](CreateApiKeyResponseBuilder::environment)
    /// - [`id`](CreateApiKeyResponseBuilder::id)
    /// - [`key`](CreateApiKeyResponseBuilder::key)
    /// - [`label`](CreateApiKeyResponseBuilder::label)
    /// - [`prefix`](CreateApiKeyResponseBuilder::prefix)
    /// - [`scopes`](CreateApiKeyResponseBuilder::scopes)
    pub fn build(self) -> Result<CreateApiKeyResponse, BuildError> {
        Ok(CreateApiKeyResponse {
            environment: self
                .environment
                .ok_or_else(|| BuildError::missing_field("environment"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            key: self.key.ok_or_else(|| BuildError::missing_field("key"))?,
            label: self
                .label
                .ok_or_else(|| BuildError::missing_field("label"))?,
            prefix: self
                .prefix
                .ok_or_else(|| BuildError::missing_field("prefix"))?,
            scopes: self
                .scopes
                .ok_or_else(|| BuildError::missing_field("scopes"))?,
        })
    }
}
