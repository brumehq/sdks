use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;

pub struct PublicClient {
    pub http_client: HttpClient,
}

impl PublicClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    pub async fn health(&self, options: Option<RequestOptions>) -> Result<(), ApiError> {
        self.http_client
            .execute_request(Method::GET, "health", None, None, options)
            .await
    }

    /// Prometheus-compatible metrics endpoint.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// Empty response
    pub async fn metrics(&self, options: Option<RequestOptions>) -> Result<(), ApiError> {
        self.http_client
            .execute_request(Method::GET, "metrics", None, None, options)
            .await
    }

    /// Public (no auth) so SDK-generation tools (Fern, Stainless, etc.) can
    /// fetch the spec without holding a Brume API key. The spec itself only
    /// describes existence of routes; it does not leak auth bypass — every
    /// documented operation still requires the appropriate security
    /// credentials at request time.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// Empty response
    pub async fn openapi_spec(&self, options: Option<RequestOptions>) -> Result<(), ApiError> {
        self.http_client
            .execute_request(Method::GET, "openapi.json", None, None, options)
            .await
    }

    pub async fn readyz(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<ReadyzResponse, ApiError> {
        self.http_client
            .execute_request(Method::GET, "readyz", None, None, options)
            .await
    }
}
