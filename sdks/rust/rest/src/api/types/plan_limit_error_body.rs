pub use crate::prelude::*;

/// `PLAN_LIMIT` error body. Emitted by the publish / create-project /
/// create-key / SSE / long-poll paths when the project hits a per-axis
/// cap. The `code` is always `"PLAN_LIMIT"`; the `reason` is a closed
/// enum string SDK consumers can pattern-match on.
#[derive(Debug, Clone, Serialize, Deserialize, Default, PartialEq, Eq, Hash)]
pub struct PlanLimitErrorBody {
    /// Always `"PLAN_LIMIT"`.
    #[serde(default)]
    pub code: String,
    /// Current count for the axis that triggered the limit.
    #[serde(default)]
    pub current: i64,
    /// The cap value, or `null` for unlimited (e.g. business tier
    /// connection cap).
    #[serde(skip_serializing_if = "Option::is_none")]
    pub limit: Option<i64>,
    /// Human-readable message. Includes the current/limit numbers
    /// and the upgrade suggestion.
    #[serde(default)]
    pub message: String,
    /// The closed-set reason. See `PlanLimitReason` in
    /// `channels/types.rs` for the full list.
    #[serde(default)]
    pub reason: String,
    /// The next tier up the ladder that lifts this axis, or `null`
    /// when the customer is already on business.
    #[serde(rename = "upgradeTier")]
    #[serde(skip_serializing_if = "Option::is_none")]
    pub upgrade_tier: Option<String>,
}

impl PlanLimitErrorBody {
    pub fn builder() -> PlanLimitErrorBodyBuilder {
        <PlanLimitErrorBodyBuilder as Default>::default()
    }
}

#[derive(Clone, PartialEq, Default, Debug)]
#[non_exhaustive]
pub struct PlanLimitErrorBodyBuilder {
    code: Option<String>,
    current: Option<i64>,
    limit: Option<i64>,
    message: Option<String>,
    reason: Option<String>,
    upgrade_tier: Option<String>,
}

impl PlanLimitErrorBodyBuilder {
    pub fn code(mut self, value: impl Into<String>) -> Self {
        self.code = Some(value.into());
        self
    }

    pub fn current(mut self, value: i64) -> Self {
        self.current = Some(value);
        self
    }

    pub fn limit(mut self, value: i64) -> Self {
        self.limit = Some(value);
        self
    }

    pub fn message(mut self, value: impl Into<String>) -> Self {
        self.message = Some(value.into());
        self
    }

    pub fn reason(mut self, value: impl Into<String>) -> Self {
        self.reason = Some(value.into());
        self
    }

    pub fn upgrade_tier(mut self, value: impl Into<String>) -> Self {
        self.upgrade_tier = Some(value.into());
        self
    }

    /// Consumes the builder and constructs a [`PlanLimitErrorBody`].
    /// This method will fail if any of the following fields are not set:
    /// - [`code`](PlanLimitErrorBodyBuilder::code)
    /// - [`current`](PlanLimitErrorBodyBuilder::current)
    /// - [`message`](PlanLimitErrorBodyBuilder::message)
    /// - [`reason`](PlanLimitErrorBodyBuilder::reason)
    pub fn build(self) -> Result<PlanLimitErrorBody, BuildError> {
        Ok(PlanLimitErrorBody {
            code: self.code.ok_or_else(|| BuildError::missing_field("code"))?,
            current: self
                .current
                .ok_or_else(|| BuildError::missing_field("current"))?,
            limit: self.limit,
            message: self
                .message
                .ok_or_else(|| BuildError::missing_field("message"))?,
            reason: self
                .reason
                .ok_or_else(|| BuildError::missing_field("reason"))?,
            upgrade_tier: self.upgrade_tier,
        })
    }
}
