# Reference
<details><summary><code>client.<a href="src/brume/client.py">diagnostics</a>() -> typing.Dict[str, typing.Any]</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.diagnostics()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## public
<details><summary><code>client.public.<a href="src/brume/public/client.py">health</a>()</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.public.health()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="src/brume/public/client.py">metrics</a>()</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.public.metrics()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="src/brume/public/client.py">openapi_spec</a>()</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.public.openapi_spec()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="src/brume/public/client.py">readyz</a>() -> ReadyzResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.public.readyz()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## stats
<details><summary><code>client.stats.<a href="src/brume/stats/client.py">analytics</a>(...) -> typing.Dict[str, typing.Any]</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.stats.analytics()

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

**window_secs:** `typing.Optional[int]` — Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.stats.<a href="src/brume/stats/client.py">get_stats</a>() -> typing.Dict[str, typing.Any]</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.stats.get_stats()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## api-keys
<details><summary><code>client.api_keys.<a href="src/brume/api_keys/client.py">list_api_keys</a>() -> ApiKeyListResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.api_keys.list_api_keys()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.api_keys.<a href="src/brume/api_keys/client.py">create_api_key</a>(...) -> CreateApiKeyResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.api_keys.create_api_key(
    environment="environment",
    label="label",
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

**environment:** `str` 

`"live"` or `"test"`. Determines the key prefix
(`pk_live_` vs `pk_test_`) and the default scope set.
    
</dd>
</dl>

<dl>
<dd>

**label:** `str` — Human-readable label. Shown in the dashboard.
    
</dd>
</dl>

<dl>
<dd>

**scopes:** `typing.Optional[typing.List[ApiKeyScope]]` 

Optional explicit scopes. Omit to receive the default scope set
(`publish`, `read_stats`, `manage_keys`).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.api_keys.<a href="src/brume/api_keys/client.py">revoke_api_key</a>(...) -> RevokeApiKeyResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.api_keys.revoke_api_key(
    id="id",
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

**id:** `str` — Hex-encoded API key id (16 bytes → 32 hex chars).
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## channels
<details><summary><code>client.channels.<a href="src/brume/channels/client.py">list_channels</a>() -> ChannelListResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.channels.list_channels()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="src/brume/channels/client.py">get_presence</a>(...) -> PresenceResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.channels.get_presence(
    channel="channel",
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

**channel:** `str` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="src/brume/channels/client.py">publish</a>(...) -> PublishResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.channels.publish(
    channel="channel",
    event="event",
    payload={
        "key": "value"
    },
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

**channel:** `str` — Channel name. Must contain at least one `:` separator (e.g., `room:123`). 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`.
    
</dd>
</dl>

<dl>
<dd>

**event:** `str` 

Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
Must NOT start with `brume:` (reserved for system events).
    
</dd>
</dl>

<dl>
<dd>

**payload:** `typing.Dict[str, typing.Any]` — Free-form JSON payload delivered to subscribers.
    
</dd>
</dl>

<dl>
<dd>

**ref:** `typing.Optional[str]` — Optional client-generated idempotency key. Echoed in `brume:ack`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="src/brume/channels/client.py">connect</a>(...)</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.channels.connect()

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

**token:** `typing.Optional[str]` — Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## longpoll
<details><summary><code>client.longpoll.<a href="src/brume/longpoll/client.py">long_poll_channel</a>(...)</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.longpoll.long_poll_channel(
    channel="channel",
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

**channel:** `str` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## postgres
<details><summary><code>client.postgres.<a href="src/brume/postgres/client.py">doctor</a>() -> typing.Dict[str, typing.Any]</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.postgres.doctor()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## projects
<details><summary><code>client.projects.<a href="src/brume/projects/client.py">get_project</a>() -> ProjectResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.projects.get_project()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="src/brume/projects/client.py">create_project</a>(...) -> CreateProjectResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.projects.create_project(
    name="name",
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

**name:** `str` — 1-128 chars.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="src/brume/projects/client.py">update_project_tier</a>(...) -> UpdateProjectTierResponse</code></summary>
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

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.projects.update_project_tier(
    id="id",
    tier="tier",
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

**id:** `str` — Hex-encoded project id (16 bytes → 32 hex chars).
    
</dd>
</dl>

<dl>
<dd>

**tier:** `str` — One of `"free" | "starter" | "pro" | "business"`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## sse
<details><summary><code>client.sse.<a href="src/brume/sse/client.py">subscribe_sse</a>(...)</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.sse.subscribe_sse(
    channel="channel",
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

**channel:** `str` — Channel name. Same rules as publish.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## webhooks
<details><summary><code>client.webhooks.<a href="src/brume/webhooks/client.py">list</a>() -> WebhookListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.webhooks.list()

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

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="src/brume/webhooks/client.py">create</a>(...) -> WebhookCreatedResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.webhooks.create(
    events=[
        "events"
    ],
    url="url",
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

**events:** `typing.List[str]` — Event names to subscribe to (e.g. `["channel.message.published"]`).
    
</dd>
</dl>

<dl>
<dd>

**url:** `str` — Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="src/brume/webhooks/client.py">delete</a>(...) -> WebhookDeleteResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.webhooks.delete(
    id="id",
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

**id:** `str` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="src/brume/webhooks/client.py">list_deliveries</a>(...) -> WebhookDeliveryListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.webhooks.list_deliveries(
    id="id",
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

**id:** `str` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="src/brume/webhooks/client.py">test</a>(...) -> WebhookTestResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```python
from brume import BrumeClient

client = BrumeClient(
    api_key="<token>",
    base_url="https://yourhost.com/path/to/api",
)

client.webhooks.test(
    id="id",
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

**id:** `str` — Webhook UUID.
    
</dd>
</dl>

<dl>
<dd>

**request_options:** `typing.Optional[RequestOptions]` — Request-specific configuration.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

