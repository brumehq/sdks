use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;

pub struct ApiKeysClient {
    pub http_client: HttpClient,
}

impl ApiKeysClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    /// Returns a list of API keys for the authenticated project.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn list_api_keys(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<ApiKeyListResponse, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/api-keys", None, None, options)
            .await
    }

    /// Creates a new API key for the authenticated project.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn create_api_key(
        &self,
        request: &CreateApiKeyRequest,
        options: Option<RequestOptions>,
    ) -> Result<CreateApiKeyResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::POST,
                "v1/api-keys",
                Some(serde_json::to_value(request).map_err(ApiError::Serialization)?),
                None,
                options,
            )
            .await
    }

    /// Revokes an API key for the authenticated project.
    ///
    /// # Arguments
    ///
    /// * `id` - Hex-encoded API key id (16 bytes → 32 hex chars).
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn revoke_api_key(
        &self,
        id: &str,
        options: Option<RequestOptions>,
    ) -> Result<RevokeApiKeyResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::DELETE,
                &format!("v1/api-keys/{}", id),
                None,
                None,
                options,
            )
            .await
    }
}
