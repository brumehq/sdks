pub use crate::prelude::*;

/// `GET /readyz` success body. The 200 / 503 distinction is what load
/// balancers key on; the body is for human debugging.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ReadyzResponse {
    /// Always `"ready"`.
    #[serde(default)]
    pub status: String,
}

impl ReadyzResponse {
    pub fn builder() -> ReadyzResponseBuilder {
        <ReadyzResponseBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ReadyzResponseBuilder {
    status: Option<String>,
}

impl ReadyzResponseBuilder {
    pub fn status(mut self, value: impl Into<String>) -> Self {
        self.status = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`ReadyzResponse`].
    /// This method will fail if any of the following fields are not set:
    /// - [`status`](ReadyzResponseBuilder::status)
    pub fn build(self) -> Result<ReadyzResponse, BuildError> {
        Ok(ReadyzResponse {
            status: self
                .status
                .ok_or_else(|| BuildError::missing_field("status"))?,
        })
    }
}
