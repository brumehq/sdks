use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, QueryBuilder, RequestOptions};
use reqwest::Method;
use std::collections::HashMap;

pub struct StatsClient {
    pub http_client: HttpClient,
}

impl StatsClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    /// Returns the project's analytics history as a list of snapshots
    /// (oldest first). Snapshots are sampled every 30s in-process. The
    /// response includes the last `window / interval` entries. Empty
    /// state is an empty `snapshots` array — never faked data.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`: the shape is pinned by tests.
    ///
    /// # Arguments
    ///
    /// * `window_secs` - Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn analytics(
        &self,
        request: &AnalyticsQueryRequest,
        options: Option<RequestOptions>,
    ) -> Result<HashMap<String, serde_json::Value>, ApiError> {
        self.http_client
            .execute_request(
                Method::GET,
                "v1/analytics",
                None,
                QueryBuilder::new()
                    .int("window_secs", request.window_secs.clone())
                    .build(),
                options,
            )
            .await
    }

    /// Returns project-level and global connection/channel statistics.
    ///
    /// Backwards compatibility: existing fields are preserved exactly. New
    /// fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
    /// slow_consumer_disconnections, dead_connections_cleaned,
    /// auth_failures_last_minute, plan_limit_rejections, top_channels) are
    /// additive — older dashboard clients keep working.
    ///
    /// Response body is documented as `additionalProperties: true` because
    /// the exact JSON shape is pinned by ~10 unit tests in this file. A
    /// future PR can type the envelope; for now SDK consumers will see
    /// `Record<string, any>`.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn get_stats(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<HashMap<String, serde_json::Value>, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/stats", None, None, options)
            .await
    }
}
