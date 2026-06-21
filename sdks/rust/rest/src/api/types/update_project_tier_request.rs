pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct UpdateProjectTierRequest {
    /// One of `"free" | "starter" | "pro" | "business"`.
    #[serde(default)]
    pub tier: String,
}

impl UpdateProjectTierRequest {
    pub fn builder() -> UpdateProjectTierRequestBuilder {
        <UpdateProjectTierRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct UpdateProjectTierRequestBuilder {
    tier: Option<String>,
}

impl UpdateProjectTierRequestBuilder {
    pub fn tier(mut self, value: impl Into<String>) -> Self {
        self.tier = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`UpdateProjectTierRequest`].
    /// This method will fail if any of the following fields are not set:
    /// - [`tier`](UpdateProjectTierRequestBuilder::tier)
    pub fn build(self) -> Result<UpdateProjectTierRequest, BuildError> {
        Ok(UpdateProjectTierRequest {
            tier: self.tier.ok_or_else(|| BuildError::missing_field("tier"))?,
        })
    }
}
