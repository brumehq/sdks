pub use crate::prelude::*;

/// Query parameters for analytics
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct AnalyticsQueryRequest {
    /// Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    #[serde(skip_serializing_if = "Option::is_none")]
    pub window_secs: Option<i64>,
}

impl AnalyticsQueryRequest {
    pub fn builder() -> AnalyticsQueryRequestBuilder {
        <AnalyticsQueryRequestBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct AnalyticsQueryRequestBuilder {
    window_secs: Option<i64>,
}

impl AnalyticsQueryRequestBuilder {
    pub fn window_secs(mut self, value: i64) -> Self {
        self.window_secs = Some(value);
        self
    }

    /// Consumes the builder and constructs a [`AnalyticsQueryRequest`].
    pub fn build(self) -> Result<AnalyticsQueryRequest, BuildError> {
        Ok(AnalyticsQueryRequest {
            window_secs: self.window_secs,
        })
    }
}
