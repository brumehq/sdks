use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;
use std::collections::HashMap;

pub struct PostgresClient {
    pub http_client: HttpClient,
}

impl PostgresClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    /// Returns the operational state of the Postgres WAL logical
    /// replication slot for the authenticated project. Project API key
    /// auth (any scope). The doctor reads the gateway's in-process cache
    /// — the numbers reflect the gateway that handled the request, not
    /// a globally-consistent cluster view.
    ///
    /// Response body is documented as `additionalProperties: true` for
    /// the same reason as `/v1/stats`.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn doctor(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<HashMap<String, serde_json::Value>, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/postgres/doctor", None, None, options)
            .await
    }
}
