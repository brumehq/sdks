pub use crate::prelude::*;

/// `PATCH /v1/projects/:id/tier` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct UpdateProjectTierResponse {
    /// Echo of the path param (hex-encoded project id).
    #[serde(default)]
    pub id: String,
    #[serde(default)]
    pub max_connections: i64,
    #[serde(default)]
    pub tier: String,
}

impl UpdateProjectTierResponse {
    pub fn builder() -> UpdateProjectTierResponseBuilder {
        <UpdateProjectTierResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct UpdateProjectTierResponseBuilder {
    id: Option<String>,
    max_connections: Option<i64>,
    tier: Option<String>,
}

impl UpdateProjectTierResponseBuilder {
    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn max_connections(mut self, value: i64) -> Self {
        self.max_connections = Some(value);
        self
    }

    pub fn tier(mut self, value: impl Into<String>) -> Self {
        self.tier = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`UpdateProjectTierResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`id`](UpdateProjectTierResponseBuilder::id)
    /// - [`max_connections`](UpdateProjectTierResponseBuilder::max_connections)
    /// - [`tier`](UpdateProjectTierResponseBuilder::tier)
    pub fn build(self) -> Result<UpdateProjectTierResponse, BuildError> {
        Ok(UpdateProjectTierResponse {
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            max_connections: self
                .max_connections
                .ok_or_else(|| BuildError::missing_field("max_connections"))?,
            tier: self.tier.ok_or_else(|| BuildError::missing_field("tier"))?,
        })
    }
}
