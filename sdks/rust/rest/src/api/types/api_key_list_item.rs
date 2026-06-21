pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ApiKeyListItem {
    #[serde(default)]
    pub environment: String,
    #[serde(default)]
    pub id: String,
    #[serde(default)]
    pub label: String,
    /// RFC-3339 timestamp of last use, or `null` if never used.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub last_used_at: Option<String>,
    #[serde(default)]
    pub prefix: String,
    /// Granted scopes (E6). Serializes as snake_case strings.
    #[serde(default)]
    pub scopes: Vec<ApiKeyScope>,
}

impl ApiKeyListItem {
    pub fn builder() -> ApiKeyListItemBuilder {
        <ApiKeyListItemBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ApiKeyListItemBuilder {
    environment: Option<String>,
    id: Option<String>,
    label: Option<String>,
    last_used_at: Option<String>,
    prefix: Option<String>,
    scopes: Option<Vec<ApiKeyScope>>,
}

impl ApiKeyListItemBuilder {
    pub fn environment(mut self, value: impl Into<String>) -> Self {
        self.environment = Some(value.into());
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn label(mut self, value: impl Into<String>) -> Self {
        self.label = Some(value.into());
        self
    }

    pub fn last_used_at(mut self, value: impl Into<String>) -> Self {
        self.last_used_at = Some(value.into());
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

    /// Consumes the builder and constructs a [`ApiKeyListItem`].
    /// This method will fail if any of the following fields are not set:
    /// - [`environment`](ApiKeyListItemBuilder::environment)
    /// - [`id`](ApiKeyListItemBuilder::id)
    /// - [`label`](ApiKeyListItemBuilder::label)
    /// - [`prefix`](ApiKeyListItemBuilder::prefix)
    /// - [`scopes`](ApiKeyListItemBuilder::scopes)
    pub fn build(self) -> Result<ApiKeyListItem, BuildError> {
        Ok(ApiKeyListItem {
            environment: self
                .environment
                .ok_or_else(|| BuildError::missing_field("environment"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            label: self
                .label
                .ok_or_else(|| BuildError::missing_field("label"))?,
            last_used_at: self.last_used_at,
            prefix: self
                .prefix
                .ok_or_else(|| BuildError::missing_field("prefix"))?,
            scopes: self
                .scopes
                .ok_or_else(|| BuildError::missing_field("scopes"))?,
        })
    }
}
