pub use crate::prelude::*;

#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ChannelSummary {
    /// Hex-encoded 16-byte project-scoped channel id.
    #[serde(default)]
    pub id: String,
    #[serde(default)]
    pub name: String,
}

impl ChannelSummary {
    pub fn builder() -> ChannelSummaryBuilder {
        <ChannelSummaryBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ChannelSummaryBuilder {
    id: Option<String>,
    name: Option<String>,
}

impl ChannelSummaryBuilder {
    pub fn id(mut self, value: impl Into<String>) -> Self {
        self.id = Some(value.into());
        self
    }

    pub fn name(mut self, value: impl Into<String>) -> Self {
        self.name = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`ChannelSummary`].
    /// This method will fail if any of the following fields are not set:
    /// - [`id`](ChannelSummaryBuilder::id)
    /// - [`name`](ChannelSummaryBuilder::name)
    pub fn build(self) -> Result<ChannelSummary, BuildError> {
        Ok(ChannelSummary {
            id: self.id.ok_or_else(|| BuildError::missing_field("id"))?,
            name: self.name.ok_or_else(|| BuildError::missing_field("name"))?,
        })
    }
}
