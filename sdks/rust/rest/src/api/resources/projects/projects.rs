use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;

pub struct ProjectsClient {
    pub http_client: HttpClient,
}

impl ProjectsClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    /// Returns full project info for the dashboard.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn get_project(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<ProjectResponse, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/project", None, None, options)
            .await
    }

    /// Creates a new project with an initial API key. Gated on email verification.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn create_project(
        &self,
        request: &CreateProjectRequest,
        options: Option<RequestOptions>,
    ) -> Result<CreateProjectResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::POST,
                "v1/projects",
                Some(serde_json::to_value(request).map_err(ApiError::Serialization)?),
                None,
                options,
            )
            .await
    }

    /// Internal sync endpoint used by the dashboard after Polar.sh webhook
    /// processing. Gated by `BRUME_INTERNAL_TOKEN`.
    ///
    /// # Arguments
    ///
    /// * `id` - Hex-encoded project id (16 bytes → 32 hex chars).
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn update_project_tier(
        &self,
        id: &str,
        request: &UpdateProjectTierRequest,
        options: Option<RequestOptions>,
    ) -> Result<UpdateProjectTierResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::PATCH,
                &format!("v1/projects/{}/tier", id),
                Some(serde_json::to_value(request).map_err(ApiError::Serialization)?),
                None,
                options,
            )
            .await
    }
}
