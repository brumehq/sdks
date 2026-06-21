# Reference
<details><summary><code>client.<a href="/lib/Brume/client.rb">diagnostics</a>() -> Internal::Types::Hash[String, Object]</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns the full operational picture for a project: counters,
latency percentiles, Postgres lag, top channels, and a plan-limit
snapshot. Project API key auth (any scope). No secrets, no
high-cardinality data, no admin gating.

Response body is documented as `additionalProperties: true` for
the same reason as `/v1/stats` and `/v1/analytics`.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.diagnostics
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## public
<details><summary><code>client.public.<a href="/lib/Brume/public/client.rb">health</a>() -> </code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.public.health
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Public::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/lib/Brume/public/client.rb">metrics</a>() -> </code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Prometheus-compatible metrics endpoint.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.public.metrics
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Public::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/lib/Brume/public/client.rb">openapi_spec</a>() -> </code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Public (no auth) so SDK-generation tools (Fern, Stainless, etc.) can
fetch the spec without holding a Brume API key. The spec itself only
describes existence of routes; it does not leak auth bypass — every
documented operation still requires the appropriate security
credentials at request time.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.public.openapi_spec
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Public::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/lib/Brume/public/client.rb">readyz</a>() -> Brume::Types::ReadyzResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.public.readyz
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Public::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## stats
<details><summary><code>client.stats.<a href="/lib/Brume/stats/client.rb">analytics</a>() -> Internal::Types::Hash[String, Object]</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns the project's analytics history as a list of snapshots
(oldest first). Snapshots are sampled every 30s in-process. The
response includes the last `window / interval` entries. Empty
state is an empty `snapshots` array — never faked data.

Response body is documented as `additionalProperties: true` for
the same reason as `/v1/stats`: the shape is pinned by tests.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.stats.analytics
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**window_secs:** `Integer` — Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Stats::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.stats.<a href="/lib/Brume/stats/client.rb">get_stats</a>() -> Internal::Types::Hash[String, Object]</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns project-level and global connection/channel statistics.

Backwards compatibility: existing fields are preserved exactly. New
fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
slow_consumer_disconnections, dead_connections_cleaned,
auth_failures_last_minute, plan_limit_rejections, top_channels) are
additive — older dashboard clients keep working.

Response body is documented as `additionalProperties: true` because
the exact JSON shape is pinned by ~10 unit tests in this file. A
future PR can type the envelope; for now SDK consumers will see
`Record<string, any>`.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.stats.get_stats
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Stats::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## api-keys
<details><summary><code>client.api_keys.<a href="/lib/Brume/api_keys/client.rb">list_api_keys</a>() -> Brume::Types::APIKeyListResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns a list of API keys for the authenticated project.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.api_keys.list_api_keys
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::APIKeys::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.api_keys.<a href="/lib/Brume/api_keys/client.rb">create_api_key</a>(request) -> Brume::Types::CreateAPIKeyResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Creates a new API key for the authenticated project.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.api_keys.create_api_key(
  environment: "environment",
  label: "label"
)
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**environment:** `String` 

`"live"` or `"test"`. Determines the key prefix
(`pk_live_` vs `pk_test_`) and the default scope set.
    
</dd>
</dl>

<dl>
<dd>

**label:** `String` — Human-readable label. Shown in the dashboard.
    
</dd>
</dl>

<dl>
<dd>

**scopes:** `Internal::Types::Array[Brume::Types::APIKeyScope]` 

Optional explicit scopes. Omit to receive the default scope set
(`publish`, `read_stats`, `manage_keys`).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::APIKeys::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.api_keys.<a href="/lib/Brume/api_keys/client.rb">revoke_api_key</a>(id) -> Brume::Types::RevokeAPIKeyResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Revokes an API key for the authenticated project.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.api_keys.revoke_api_key(id: "id")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**id:** `String` — Hex-encoded API key id (16 bytes → 32 hex chars).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::APIKeys::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## channels
<details><summary><code>client.channels.<a href="/lib/Brume/channels/client.rb">list_channels</a>() -> Brume::Types::ChannelListResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns a list of all channels for the authenticated project.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.channels.list_channels
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Channels::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/lib/Brume/channels/client.rb">get_presence</a>(channel) -> Brume::Types::PresenceResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns the current presence roster for a channel.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.channels.get_presence(channel: "channel")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**channel:** `String` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Channels::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/lib/Brume/channels/client.rb">publish</a>(channel, request) -> Brume::Types::PublishResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Server-side REST publish endpoint for non-WebSocket backends
(cron jobs, webhooks, queue workers).
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.channels.publish(
  channel: "channel",
  event: "event",
  payload: {}
)
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**channel:** `String` — Channel name. Must contain at least one `:` separator (e.g., `room:123`). 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`.
    
</dd>
</dl>

<dl>
<dd>

**event:** `String` 

Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
Must NOT start with `brume:` (reserved for system events).
    
</dd>
</dl>

<dl>
<dd>

**payload:** `Internal::Types::Hash[String, Object]` — Free-form JSON payload delivered to subscribers.
    
</dd>
</dl>

<dl>
<dd>

**ref:** `String` — Optional client-generated idempotency key. Echoed in `brume:ack`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Channels::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/lib/Brume/channels/client.rb">connect</a>() -> </code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

JWT extraction priority:
1. `Sec-WebSocket-Protocol: brume.token.<jwt>` (recommended — keeps the
   token out of access logs, browser history, and referer headers).
2. `?token=<jwt>` query parameter (legacy; emits a deprecation warning).

If auth fails, returns an HTTP error response without upgrading.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.channels.connect
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**token:** `String` — Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Channels::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## longpoll
<details><summary><code>client.longpoll.<a href="/lib/Brume/longpoll/client.rb">long_poll_channel</a>(channel) -> </code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.longpoll.long_poll_channel(channel: "channel")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**channel:** `String` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Longpoll::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## postgres
<details><summary><code>client.postgres.<a href="/lib/Brume/postgres/client.rb">doctor</a>() -> Internal::Types::Hash[String, Object]</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns the operational state of the Postgres WAL logical
replication slot for the authenticated project. Project API key
auth (any scope). The doctor reads the gateway's in-process cache
— the numbers reflect the gateway that handled the request, not
a globally-consistent cluster view.

Response body is documented as `additionalProperties: true` for
the same reason as `/v1/stats`.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.postgres.doctor
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Postgres::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## projects
<details><summary><code>client.projects.<a href="/lib/Brume/projects/client.rb">get_project</a>() -> Brume::Types::ProjectResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Returns full project info for the dashboard.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.projects.get_project
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Projects::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="/lib/Brume/projects/client.rb">create_project</a>(request) -> Brume::Types::CreateProjectResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Creates a new project with an initial API key. Gated on email verification.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.projects.create_project(name: "name")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**name:** `String` — 1-128 chars.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Projects::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="/lib/Brume/projects/client.rb">update_project_tier</a>(id, request) -> Brume::Types::UpdateProjectTierResponse</code></summary>
<dl>
<dd>

#### 📝 Description

<dl>
<dd>

<dl>
<dd>

Internal sync endpoint used by the dashboard after Polar.sh webhook
processing. Gated by `BRUME_INTERNAL_TOKEN`.
</dd>
</dl>
</dd>
</dl>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.projects.update_project_tier(
  id: "id",
  tier: "tier"
)
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**id:** `String` — Hex-encoded project id (16 bytes → 32 hex chars).
    
</dd>
</dl>

<dl>
<dd>

**tier:** `String` — One of `"free" | "starter" | "pro" | "business"`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Projects::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## sse
<details><summary><code>client.sse.<a href="/lib/Brume/sse/client.rb">subscribe_sse</a>(channel) -> </code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.sse.subscribe_sse(channel: "channel")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**channel:** `String` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Sse::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## webhooks
<details><summary><code>client.webhooks.<a href="/lib/Brume/webhooks/client.rb">list</a>() -> Brume::Types::WebhookListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.webhooks.list
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**request_options:** `Brume::Webhooks::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/lib/Brume/webhooks/client.rb">create</a>(request) -> Brume::Types::WebhookCreatedResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.webhooks.create(
  events: ["events"],
  url: "url"
)
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**events:** `Internal::Types::Array[String]` — Event names to subscribe to (e.g. `["channel.message.published"]`).
    
</dd>
</dl>

<dl>
<dd>

**url:** `String` — Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Webhooks::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/lib/Brume/webhooks/client.rb">delete</a>(id) -> Brume::Types::WebhookDeleteResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.webhooks.delete(id: "id")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**id:** `String` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Webhooks::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/lib/Brume/webhooks/client.rb">list_deliveries</a>(id) -> Brume::Types::WebhookDeliveryListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.webhooks.list_deliveries(id: "id")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**id:** `String` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Webhooks::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/lib/Brume/webhooks/client.rb">test</a>(id) -> Brume::Types::WebhookTestResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```ruby
client.webhooks.test(id: "id")
```
</dd>
</dl>
</dd>
</dl>

#### ⚙️ Parameters

<dl>
<dd>

<dl>
<dd>

**id:** `String` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `Brume::Webhooks::RequestOptions` 
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

