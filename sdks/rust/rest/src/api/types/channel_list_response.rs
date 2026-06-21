pub use crate::prelude::*;

/// `GET /v1/channels` success response.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ChannelListResponse {
    #[serde(default)]
    pub channels: Vec<ChannelSummary>,
}

impl ChannelListResponse {
    pub fn builder() -> ChannelListResponseBuilder {
        <ChannelListResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ChannelListResponseBuilder {
    channels: Option<Vec<ChannelSummary>>,
}

impl ChannelListResponseBuilder {
    pub fn channels(mut self, value: Vec<ChannelSummary>) -> Self {
        self.channels = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`ChannelListResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`channels`](ChannelListResponseBuilder::channels)
    pub fn build(self) -> Result<ChannelListResponse, BuildError> {
        Ok(ChannelListResponse {
            channels: self
                .channels
                .ok_or_else(|| BuildError::missing_field("channels"))?,
        })
    }
}
