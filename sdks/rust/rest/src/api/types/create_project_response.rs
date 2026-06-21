pub use crate::prelude::*;

/// `POST /v1/projects` success response. The `api_key` field is the only
/// time the raw key is returned; clients must store it immediately.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct CreateProjectResponse {
    /// The raw API key. `null` after the first call (the server does
    /// not retain plaintext keys).
    #[serde(default)]
    pub api_key: String,
    /// Hex-encoded 16-byte project id.
    #[serde(default)]
    pub id: String,
    #[serde(default)]
    pub max_connections: i64,
    #[serde(default)]
    pub name: String,
    #[serde(default)]
    pub tier: String,
}

impl CreateProjectResponse {
    pub fn builder() -> CreateProjectResponseBuilder {
        <CreateProjectResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct CreateProjectResponseBuilder {
    api_key: Option<String>,
    id: Option<String>,
    max_connections: Option<i64>,
    name: Option<String>,
    tier: Option<String>,
}

impl CreateProjectResponseBuilder {
    pub fn api_key(mut self, value: impl Into<String>) -> Self {
        self.api_key = Some(value.into());
        self
    }

    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn max_connections(mut self, value: i64) -> Self {
        self.max_connections = Some(value);
        self
    }

    pub fn name(mut self, value: impl Into<String>) -> Self {
        self.name = Some(value.into());
        self
    }

    pub fn tier(mut self, value: impl Into<String>) -> Self {
        self.tier = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`CreateProjectResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`api_key`](CreateProjectResponseBuilder::api_key)
    /// - [`id`](CreateProjectResponseBuilder::id)
    /// - [`max_connections`](CreateProjectResponseBuilder::max_connections)
    /// - [`name`](CreateProjectResponseBuilder::name)
    /// - [`tier`](CreateProjectResponseBuilder::tier)
    pub fn build(self) -> Result<CreateProjectResponse, BuildError> {
        Ok(CreateProjectResponse {
            api_key: self
                .api_key
                .ok_or_else(|| BuildError::missing_field("api_key"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            max_connections: self
                .max_connections
                .ok_or_else(|| BuildError::missing_field("max_connections"))?,
            name: self.name.ok_or_else(|| BuildError::missing_field("name"))?,
            tier: self.tier.ok_or_else(|| BuildError::missing_field("tier"))?,
        })
    }
}
