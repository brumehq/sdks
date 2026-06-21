pub use crate::prelude::*;

/// Standard error response body returned by all REST endpoints on 4xx/5xx.
///
/// The legacy handlers emit `{"error": "..."}` (string-only). The newer
/// handlers emit `{"error": "CODE", "message": "human-readable"}`. Both
/// shapes parse into this struct; the `message` field is optional for
/// back-compat.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct ErrorBody {
    /// Short error code. Either a stable machine code (`AUTH_INVALID`,
    /// `RATE_LIMITED`, `EMAIL_NOT_VERIFIED`, etc.) or a free-form string
    /// for legacy handlers. SDK consumers should pattern-match the
    /// well-known codes and treat unknown values as opaque failures.
    #[serde(default)]
    pub error: String,
    /// Human-readable description. Absent on legacy string-only errors.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub message: Option<String>,
}

impl ErrorBody {
    pub fn builder() -> ErrorBodyBuilder {
        <ErrorBodyBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct ErrorBodyBuilder {
    error: Option<String>,
    message: Option<String>,
}

impl ErrorBodyBuilder {
    pub fn error(mut self, value: impl Into<String>) -> Self {
        self.error = Some(value.into());
        self
    }

    pub fn message(mut self, value: impl Into<String>) -> Self {
        self.message = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`ErrorBody`].
    /// This method will fail if any of the following fields are not set:
    /// - [`error`](ErrorBodyBuilder::error)
    pub fn build(self) -> Result<ErrorBody, BuildError> {
        Ok(ErrorBody {
            error: self
                .error
                .ok_or_else(|| BuildError::missing_field("error"))?,
            message: self.message,
        })
    }
}
