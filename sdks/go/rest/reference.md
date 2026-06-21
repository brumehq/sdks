# Reference
<details><summary><code>client.Diagnostics() -> map[string]any</code></summary>
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

```go
client.Diagnostics(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## public
<details><summary><code>client.Public.Health() -> error</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Public.Health(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Public.Metrics() -> error</code></summary>
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

```go
client.Public.Metrics(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Public.OpenapiSpec() -> error</code></summary>
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

```go
client.Public.OpenapiSpec(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Public.Readyz() -> *brume.ReadyzResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Public.Readyz(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## stats
<details><summary><code>client.Stats.Analytics() -> map[string]any</code></summary>
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

```go
request := &brume.AnalyticsRequest{}
client.Stats.Analytics(
        context.TODO(),
        request,
    )
}
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

**windowSecs:** `*int64` — Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Stats.GetStats() -> map[string]any</code></summary>
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

```go
client.Stats.GetStats(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## api-keys
<details><summary><code>client.APIKeys.ListAPIKeys() -> *brume.APIKeyListResponse</code></summary>
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

```go
client.APIKeys.ListAPIKeys(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.APIKeys.CreateAPIKey(request) -> *brume.CreateAPIKeyResponse</code></summary>
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

```go
request := &brume.CreateAPIKeyRequest{
        Environment: "environment",
        Label: "label",
    }
client.APIKeys.CreateAPIKey(
        context.TODO(),
        request,
    )
}
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

**environment:** `string` 

`"live"` or `"test"`. Determines the key prefix
(`pk_live_` vs `pk_test_`) and the default scope set.
    
</dd>
</dl>

<dl>
<dd>

**label:** `string` — Human-readable label. Shown in the dashboard.
    
</dd>
</dl>

<dl>
<dd>

**scopes:** `[]*brume.APIKeyScope` 

Optional explicit scopes. Omit to receive the default scope set
(`publish`, `read_stats`, `manage_keys`).
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.APIKeys.RevokeAPIKey(ID) -> *brume.RevokeAPIKeyResponse</code></summary>
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

```go
client.APIKeys.RevokeAPIKey(
        context.TODO(),
        "id",
    )
}
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

**id:** `string` — Hex-encoded API key id (16 bytes → 32 hex chars).
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## channels
<details><summary><code>client.Channels.ListChannels() -> *brume.ChannelListResponse</code></summary>
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

```go
client.Channels.ListChannels(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Channels.GetPresence(Channel) -> *brume.PresenceResponse</code></summary>
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

```go
client.Channels.GetPresence(
        context.TODO(),
        "channel",
    )
}
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

**channel:** `string` — Channel name. Same rules as publish.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Channels.Publish(Channel, request) -> *brume.PublishResponse</code></summary>
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

```go
request := &brume.PublishRequest{
        Event: "event",
        Payload: map[string]any{
            "key": "value",
        },
    }
client.Channels.Publish(
        context.TODO(),
        "channel",
        request,
    )
}
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

**channel:** `string` — Channel name. Must contain at least one `:` separator (e.g., `room:123`). 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`.
    
</dd>
</dl>

<dl>
<dd>

**event:** `string` 

Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
Must NOT start with `brume:` (reserved for system events).
    
</dd>
</dl>

<dl>
<dd>

**payload:** `map[string]any` — Free-form JSON payload delivered to subscribers.
    
</dd>
</dl>

<dl>
<dd>

**ref:** `*string` — Optional client-generated idempotency key. Echoed in `brume:ack`.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Channels.Connect() -> error</code></summary>
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

```go
request := &brume.ConnectRequest{}
client.Channels.Connect(
        context.TODO(),
        request,
    )
}
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

**token:** `*string` — Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## longpoll
<details><summary><code>client.Longpoll.LongPollChannel(Channel) -> error</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Longpoll.LongPollChannel(
        context.TODO(),
        "channel",
    )
}
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

**channel:** `string` — Channel name. Same rules as publish.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## postgres
<details><summary><code>client.Postgres.Doctor() -> map[string]any</code></summary>
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

```go
client.Postgres.Doctor(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## projects
<details><summary><code>client.Projects.GetProject() -> *brume.ProjectResponse</code></summary>
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

```go
client.Projects.GetProject(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Projects.CreateProject(request) -> *brume.CreateProjectResponse</code></summary>
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

```go
request := &brume.CreateProjectRequest{
        Name: "name",
    }
client.Projects.CreateProject(
        context.TODO(),
        request,
    )
}
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

**name:** `string` — 1-128 chars.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Projects.UpdateProjectTier(ID, request) -> *brume.UpdateProjectTierResponse</code></summary>
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

```go
request := &brume.UpdateProjectTierRequest{
        Tier: "tier",
    }
client.Projects.UpdateProjectTier(
        context.TODO(),
        "id",
        request,
    )
}
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

**id:** `string` — Hex-encoded project id (16 bytes → 32 hex chars).
    
</dd>
</dl>

<dl>
<dd>

**tier:** `string` — One of `"free" | "starter" | "pro" | "business"`.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## sse
<details><summary><code>client.Sse.SubscribeSse(Channel) -> error</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Sse.SubscribeSse(
        context.TODO(),
        "channel",
    )
}
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

**channel:** `string` — Channel name. Same rules as publish.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## webhooks
<details><summary><code>client.Webhooks.List() -> *brume.WebhookListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Webhooks.List(
        context.TODO(),
    )
}
```
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Webhooks.Create(request) -> *brume.WebhookCreatedResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
request := &brume.CreateWebhookRequest{
        Events: []string{
            "events",
        },
        URL: "url",
    }
client.Webhooks.Create(
        context.TODO(),
        request,
    )
}
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

**events:** `[]string` — Event names to subscribe to (e.g. `["channel.message.published"]`).
    
</dd>
</dl>

<dl>
<dd>

**url:** `string` — Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Webhooks.Delete(ID) -> *brume.WebhookDeleteResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Webhooks.Delete(
        context.TODO(),
        "id",
    )
}
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

**id:** `string` — Webhook UUID.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Webhooks.ListDeliveries(ID) -> *brume.WebhookDeliveryListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Webhooks.ListDeliveries(
        context.TODO(),
        "id",
    )
}
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

**id:** `string` — Webhook UUID.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.Webhooks.Test(ID) -> *brume.WebhookTestResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```go
client.Webhooks.Test(
        context.TODO(),
        "id",
    )
}
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

**id:** `string` — Webhook UUID.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

