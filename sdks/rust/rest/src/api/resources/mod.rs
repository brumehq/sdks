//! Service clients and API endpoints
//!
//! This module contains client implementations for:
//!
//! - **public**
//! - **stats**
//! - **api-keys**
//! - **channels**
//! - **longpoll**
//! - **postgres**
//! - **projects**
//! - **sse**
//! - **webhooks**

use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;

pub mod api_keys;
pub mod channels;
pub mod longpoll;
pub mod postgres;
pub mod projects;
pub mod public;
pub mod sse;
pub mod stats;
pub mod webhooks;
pub struct BrumeClient {
    pub config: ClientConfig,
    pub http_client: HttpClient,
    pub public: PublicClient,
    pub stats: StatsClient,
    pub api_keys: ApiKeysClient,
    pub channels: ChannelsClient,
    pub longpoll: LongpollClient,
    pub postgres: PostgresClient,
    pub projects: ProjectsClient,
    pub sse: SseClient,
    pub webhooks: WebhooksClient,
}

impl BrumeClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            config: config.clone(),
            http_client: HttpClient::new(config.clone())?,
            public: PublicClient::new(config.clone())?,
            stats: StatsClient::new(config.clone())?,
            api_keys: ApiKeysClient::new(config.clone())?,
            channels: ChannelsClient::new(config.clone())?,
            longpoll: LongpollClient::new(config.clone())?,
            postgres: PostgresClient::new(config.clone())?,
            projects: ProjectsClient::new(config.clone())?,
            sse: SseClient::new(config.clone())?,
            webhooks: WebhooksClient::new(config.clone())?,
        })
    }

    /// Returns the full operational picture for a project: counters,
    /// latency percentiles, Postgres lag, top channels, and a plan-limit
    /// snapshot. Project API key auth (any scope). No secrets, no
    /// high-cardinality data, no admin gating.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats` and `/v1/analytics`.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn diagnostics(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<HashMap<String, serde_json::Value>, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/diagnostics", None, None, options)
            .await
    }
}

pub use api_keys::ApiKeysClient;
pub use channels::ChannelsClient;
pub use longpoll::LongpollClient;
pub use postgres::PostgresClient;
pub use projects::ProjectsClient;
pub use public::PublicClient;
pub use sse::SseClient;
pub use stats::StatsClient;
pub use webhooks::WebhooksClient;
