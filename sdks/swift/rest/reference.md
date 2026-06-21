# Reference
<details><summary><code>client.<a href="/Sources/BrumeClient.swift">diagnostics</a>(requestOptions: RequestOptions?) -> [String: JSONValue]</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.diagnostics()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## public
<details><summary><code>client.public.<a href="/Sources/Resources/Public/PublicClient.swift">health</a>(requestOptions: RequestOptions?) -> Void</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.public.health()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/Sources/Resources/Public/PublicClient.swift">metrics</a>(requestOptions: RequestOptions?) -> Void</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.public.metrics()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/Sources/Resources/Public/PublicClient.swift">openapiSpec</a>(requestOptions: RequestOptions?) -> Void</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.public.openapiSpec()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.public.<a href="/Sources/Resources/Public/PublicClient.swift">readyz</a>(requestOptions: RequestOptions?) -> ReadyzResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.public.readyz()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## stats
<details><summary><code>client.stats.<a href="/Sources/Resources/Stats/StatsClient.swift">analytics</a>(windowSecs: Int64?, requestOptions: RequestOptions?) -> [String: JSONValue]</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.stats.analytics()
}

try await main()
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

**windowSecs:** `Int64?` — Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.stats.<a href="/Sources/Resources/Stats/StatsClient.swift">getStats</a>(requestOptions: RequestOptions?) -> [String: JSONValue]</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.stats.getStats()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## api-keys
<details><summary><code>client.apiKeys.<a href="/Sources/Resources/ApiKeys/ApiKeysClient.swift">listApiKeys</a>(requestOptions: RequestOptions?) -> ApiKeyListResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.apiKeys.listApiKeys()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.apiKeys.<a href="/Sources/Resources/ApiKeys/ApiKeysClient.swift">createApiKey</a>(request: Requests.CreateApiKeyRequest, requestOptions: RequestOptions?) -> CreateApiKeyResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.apiKeys.createApiKey(request: .init(
        environment: "environment",
        label: "label"
    ))
}

try await main()
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

**request:** `Requests.CreateApiKeyRequest` 
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.apiKeys.<a href="/Sources/Resources/ApiKeys/ApiKeysClient.swift">revokeApiKey</a>(id: String, requestOptions: RequestOptions?) -> RevokeApiKeyResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.apiKeys.revokeApiKey(id: "id")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## channels
<details><summary><code>client.channels.<a href="/Sources/Resources/Channels/ChannelsClient.swift">listChannels</a>(requestOptions: RequestOptions?) -> ChannelListResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.channels.listChannels()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/Sources/Resources/Channels/ChannelsClient.swift">getPresence</a>(channel: String, requestOptions: RequestOptions?) -> PresenceResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.channels.getPresence(channel: "channel")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/Sources/Resources/Channels/ChannelsClient.swift">publish</a>(channel: String, request: Requests.PublishRequest, requestOptions: RequestOptions?) -> PublishResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.channels.publish(
        channel: "channel",
        request: .init(
            event: "event",
            payload: [
                "key": .string("value")
            ]
        )
    )
}

try await main()
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

**request:** `Requests.PublishRequest` 
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.channels.<a href="/Sources/Resources/Channels/ChannelsClient.swift">connect</a>(token: String?, requestOptions: RequestOptions?) -> Void</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.channels.connect()
}

try await main()
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

**token:** `String?` — Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## longpoll
<details><summary><code>client.longpoll.<a href="/Sources/Resources/Longpoll/LongpollClient.swift">longPollChannel</a>(channel: String, requestOptions: RequestOptions?) -> Void</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.longpoll.longPollChannel(channel: "channel")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## postgres
<details><summary><code>client.postgres.<a href="/Sources/Resources/Postgres/PostgresClient.swift">doctor</a>(requestOptions: RequestOptions?) -> [String: JSONValue]</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.postgres.doctor()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## projects
<details><summary><code>client.projects.<a href="/Sources/Resources/Projects/ProjectsClient.swift">getProject</a>(requestOptions: RequestOptions?) -> ProjectResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.projects.getProject()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="/Sources/Resources/Projects/ProjectsClient.swift">createProject</a>(request: Requests.CreateProjectRequest, requestOptions: RequestOptions?) -> CreateProjectResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.projects.createProject(request: .init(name: "name"))
}

try await main()
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

**request:** `Requests.CreateProjectRequest` 
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.projects.<a href="/Sources/Resources/Projects/ProjectsClient.swift">updateProjectTier</a>(id: String, request: Requests.UpdateProjectTierRequest, requestOptions: RequestOptions?) -> UpdateProjectTierResponse</code></summary>
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

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.projects.updateProjectTier(
        id: "id",
        request: .init(tier: "tier")
    )
}

try await main()
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

**request:** `Requests.UpdateProjectTierRequest` 
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## sse
<details><summary><code>client.sse.<a href="/Sources/Resources/Sse/SseClient.swift">subscribeSse</a>(channel: String, requestOptions: RequestOptions?) -> Void</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.sse.subscribeSse(channel: "channel")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

## webhooks
<details><summary><code>client.webhooks.<a href="/Sources/Resources/Webhooks/WebhooksClient.swift">list</a>(requestOptions: RequestOptions?) -> WebhookListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.webhooks.list()
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/Sources/Resources/Webhooks/WebhooksClient.swift">create</a>(request: Requests.CreateWebhookRequest, requestOptions: RequestOptions?) -> WebhookCreatedResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.webhooks.create(request: .init(
        events: [
            "events"
        ],
        url: "url"
    ))
}

try await main()
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

**request:** `Requests.CreateWebhookRequest` 
    
</dd>
</dl>

<dl>
<dd>

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/Sources/Resources/Webhooks/WebhooksClient.swift">delete</a>(id: String, requestOptions: RequestOptions?) -> WebhookDeleteResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.webhooks.delete(id: "id")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/Sources/Resources/Webhooks/WebhooksClient.swift">listDeliveries</a>(id: String, requestOptions: RequestOptions?) -> WebhookDeliveryListResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.webhooks.listDeliveries(id: "id")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

<details><summary><code>client.webhooks.<a href="/Sources/Resources/Webhooks/WebhooksClient.swift">test</a>(id: String, requestOptions: RequestOptions?) -> WebhookTestResponse</code></summary>
<dl>
<dd>

#### 🔌 Usage

<dl>
<dd>

<dl>
<dd>

```swift
import Foundation
import Brume

private func main() async throws {
    let client = BrumeClient(apiKey: "<token>")

    _ = try await client.webhooks.test(id: "id")
}

try await main()
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

**requestOptions:** `RequestOptions?` — Additional options for configuring the request, such as custom headers or timeout settings.
    
</dd>
</dl>
</dd>
</dl>


</dd>
</dl>
</details>

