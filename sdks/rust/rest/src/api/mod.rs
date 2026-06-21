//! API client and types for the Brume Realtime Gateway
//!
//! This module contains all the API definitions including request/response types
//! and client implementations for interacting with the API.
//!
//! ## Modules
//!
//! - [`resources`] - Service clients and endpoints
//! - [`types`] - Request, response, and model types

pub mod resources;
pub mod types;

pub use resources::{
    ApiKeysClient, BrumeClient, ChannelsClient, LongpollClient, PostgresClient, ProjectsClient,
    PublicClient, SseClient, StatsClient, WebhooksClient,
};
pub use types::*;
