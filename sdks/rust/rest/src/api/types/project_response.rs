pub use crate::prelude::*;

/// `GET /v1/project` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ProjectResponse {
    /// RFC-3339 timestamp of project creation.
    #[serde(default)]
    pub created_at: String,
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

impl ProjectResponse {
    pub fn builder() -> ProjectResponseBuilder {
        <ProjectResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ProjectResponseBuilder {
    created_at: Option<String>,
    id: Option<String>,
    max_connections: Option<i64>,
    name: Option<String>,
    tier: Option<String>,
}

impl ProjectResponseBuilder {
    pub fn created_at(mut self, value: impl Into<String>) -> Self {
        self.created_at = Some(value.into());
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

    /// Consumes the builder and constructs a [`ProjectResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`created_at`](ProjectResponseBuilder::created_at)
    /// - [`id`](ProjectResponseBuilder::id)
    /// - [`max_connections`](ProjectResponseBuilder::max_connections)
    /// - [`name`](ProjectResponseBuilder::name)
    /// - [`tier`](ProjectResponseBuilder::tier)
    pub fn build(self) -> Result<ProjectResponse, BuildError> {
        Ok(ProjectResponse {
            created_at: self
                .created_at
                .ok_or_else(|| BuildError::missing_field("created_at"))?,
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            max_connections: self
                .max_connections
                .ok_or_else(|| BuildError::missing_field("max_connections"))?,
            name: self.name.ok_or_else(|| BuildError::missing_field("name"))?,
            tier: self.tier.ok_or_else(|| BuildError::missing_field("tier"))?,
        })
    }
}
