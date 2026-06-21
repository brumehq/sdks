# Reference
<details><summary><code>client.diagnostics() -> Map&amp;lt;String, Object&amp;gt;</code></summary>
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

```java
client.diagnostics();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## public
<details><summary><code>client.public_.health()</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.public_().health();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public_.metrics()</code></summary>
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

```java
client.public_().metrics();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public_.openapiSpec()</code></summary>
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

```java
client.public_().openapiSpec();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public_.readyz() -> ReadyzResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.public_().readyz();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## stats
<details><summary><code>client.stats.analytics() -> Map&amp;lt;String, Object&amp;gt;</code></summary>
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

```java
client.stats().analytics(
    AnalyticsRequest
        .builder()
        .build()
);
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

**windowSecs:** `Optional<Long>` — Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.stats.getStats() -> Map&amp;lt;String, Object&amp;gt;</code></summary>
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

```java
client.stats().getStats();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## api-keys
<details><summary><code>client.apiKeys.listApiKeys() -> ApiKeyListResponse</code></summary>
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

```java
client.apiKeys().listApiKeys();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.apiKeys.createApiKey(request) -> CreateApiKeyResponse</code></summary>
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

```java
client.apiKeys().createApiKey(
    CreateApiKeyRequest
        .builder()
        .environment("environment")
        .label("label")
        .build()
);
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

**scopes:** `Optional<List<ApiKeyScope>>` 

Optional explicit scopes. Omit to receive the default scope set
(`publish`, `read_stats`, `manage_keys`).
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.apiKeys.revokeApiKey(id) -> RevokeApiKeyResponse</code></summary>
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

```java
client.apiKeys().revokeApiKey("id");
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
</dd>
</dl>


</dd>
</dl>
</details>

## channels
<details><summary><code>client.channels.listChannels() -> ChannelListResponse</code></summary>
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

```java
client.channels().listChannels();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.getPresence(channel) -> PresenceResponse</code></summary>
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

```java
client.channels().getPresence("channel");
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
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.publish(channel, request) -> PublishResponse</code></summary>
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

```java
client.channels().publish(
    "channel",
    PublishRequest
        .builder()
        .event("event")
        .payload(
            new HashMap<String, Object>() {{
                put("key", "value");
            }}
        )
        .build()
);
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

**payload:** `Map<String, Object>` — Free-form JSON payload delivered to subscribers.
    
</dd>
</dl>

<dl>
<dd>

**ref:** `Optional<String>` — Optional client-generated idempotency key. Echoed in `brume:ack`.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.connect()</code></summary>
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

```java
client.channels().connect(
    ConnectRequest
        .builder()
        .build()
);
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

**token:** `Optional<String>` — Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## longpoll
<details><summary><code>client.longpoll.longPollChannel(channel)</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.longpoll().longPollChannel("channel");
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
</dd>
</dl>


</dd>
</dl>
</details>

## postgres
<details><summary><code>client.postgres.doctor() -> Map&amp;lt;String, Object&amp;gt;</code></summary>
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

```java
client.postgres().doctor();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## projects
<details><summary><code>client.projects.getProject() -> ProjectResponse</code></summary>
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

```java
client.projects().getProject();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.createProject(request) -> CreateProjectResponse</code></summary>
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

```java
client.projects().createProject(
    CreateProjectRequest
        .builder()
        .name("name")
        .build()
);
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
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.updateProjectTier(id, request) -> UpdateProjectTierResponse</code></summary>
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

```java
client.projects().updateProjectTier(
    "id",
    UpdateProjectTierRequest
        .builder()
        .tier("tier")
        .build()
);
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
</dd>
</dl>


</dd>
</dl>
</details>

## sse
<details><summary><code>client.sse.subscribeSse(channel)</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.sse().subscribeSse("channel");
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
</dd>
</dl>


</dd>
</dl>
</details>

## webhooks
<details><summary><code>client.webhooks.list() -> WebhookListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.webhooks().list();
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.create(request) -> WebhookCreatedResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.webhooks().create(
    CreateWebhookRequest
        .builder()
        .url("url")
        .events(
            Arrays.asList("events")
        )
        .build()
);
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

**events:** `List<String>` — Event names to subscribe to (e.g. `["channel.message.published"]`).
    
</dd>
</dl>

<dl>
<dd>

**url:** `String` — Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.delete(id) -> WebhookDeleteResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.webhooks().delete("id");
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
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.listDeliveries(id) -> WebhookDeliveryListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.webhooks().listDeliveries("id");
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
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.test(id) -> WebhookTestResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```java
client.webhooks().test("id");
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
</dd>
</dl>


</dd>
</dl>
</details>

