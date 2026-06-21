use crate::api::*;
use crate::{ApiError, ClientConfig, HttpClient, QueryBuilder, RequestOptions};
use reqwest::Method;

pub struct ChannelsClient {
    pub http_client: HttpClient,
}

impl ChannelsClient {
    pub fn new(config: ClientConfig) -> Result<Self, ApiError> {
        Ok(Self {
            http_client: HttpClient::new(config.clone())?,
        })
    }

    /// Returns a list of all channels for the authenticated project.
    ///
    /// # Arguments
    ///
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn list_channels(
        &self,
        options: Option<RequestOptions>,
    ) -> Result<ChannelListResponse, ApiError> {
        self.http_client
            .execute_request(Method::GET, "v1/channels", None, None, options)
            .await
    }

    /// Returns the current presence roster for a channel.
    ///
    /// # Arguments
    ///
    /// * `channel` - Channel name. Same rules as publish.
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn get_presence(
        &self,
        channel: &str,
        options: Option<RequestOptions>,
    ) -> Result<PresenceResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::GET,
                &format!("v1/channels/{}/presence", channel),
                None,
                None,
                options,
            )
            .await
    }

    /// Server-side REST publish endpoint for non-WebSocket backends
    /// (cron jobs, webhooks, queue workers).
    ///
    /// # Arguments
    ///
    /// * `channel` - Channel name. Must contain at least one `:` separator (e.g., `room:123`). 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`.
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// JSON response from the API
    pub async fn publish(
        &self,
        channel: &str,
        request: &PublishRequest,
        options: Option<RequestOptions>,
    ) -> Result<PublishResponse, ApiError> {
        self.http_client
            .execute_request(
                Method::POST,
                &format!("v1/channels/{}/publish", channel),
                Some(serde_json::to_value(request).map_err(ApiError::Serialization)?),
                None,
                options,
            )
            .await
    }

    /// JWT extraction priority:
    /// 1. `Sec-WebSocket-Protocol: brume.token.<jwt>` (recommended — keeps the
    /// token out of access logs, browser history, and referer headers).
    /// 2. `?token=<jwt>` query parameter (legacy; emits a deprecation warning).
    ///
    /// If auth fails, returns an HTTP error response without upgrading.
    ///
    /// # Arguments
    ///
    /// * `token` - Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    /// * `options` - Additional request options such as headers, timeout, etc.
    ///
    /// # Returns
    ///
    /// Empty response
    pub async fn connect(
        &self,
        request: &ConnectQueryRequest,
        options: Option<RequestOptions>,
    ) -> Result<(), ApiError> {
        self.http_client
            .execute_request(
                Method::GET,
                "v1/connect",
                None,
                QueryBuilder::new()
                    .string("token", request.token.clone())
                    .build(),
                options,
            )
            .await
    }
}
