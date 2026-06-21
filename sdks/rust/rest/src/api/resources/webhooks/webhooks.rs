use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, RequestOptions};
use reqwest::Method;

pub struct WebhooksClient {
    pub http_client: HttpClient,
}

impl WebhooksClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    pub async fn list(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<WebhookListResponse, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/webhooks", None, None, options)
            .await
    }

    pub async fn create(
        &self,
        request: &CreateWebhookRequest,
        options: Option<RequestOptions>,
    ) -> Result<WebhookCreatedResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::POST,
                "v1/webhooks",
                Some(serde_json::to_value(request).map_err(ApiError::Serialization)?),
                None,
                options,
            )
            .await
    }

    pub async fn delete(
        &self,
        id: &str,
        options: Option<RequestOptions>,
    ) -> Result<WebhookDeleteResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::DELETE,
                &format!("v1/webhooks/{}", id),
                None,
                None,
                options,
            )
            .await
    }

    pub async fn list_deliveries(
        &self,
        id: &str,
        options: Option<RequestOptions>,
    ) -> Result<WebhookDeliveryListResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::GET,
                &format!("v1/webhooks/{}/deliveries", id),
                None,
                None,
                options,
            )
            .await
    }

    pub async fn test(
        &self,
        id: &str,
        options: Option<RequestOptions>,
    ) -> Result<WebhookTestResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::POST,
                &format!("v1/webhooks/{}/test", id),
                None,
                None,
                options,
            )
            .await
    }
}
