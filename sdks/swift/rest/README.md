# Brume Swift Library

[![fern shield](https://img.shields.io/badge/%F0%9F%8C%BF-Built%20with%20Fern-brightgreen)](https://buildwithfern.com?utm_source=github&utm_medium=github&utm_campaign=readme&utm_source=Brume%2FSwift)
![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)

Brume is a realtime gateway for Postgres-backed applications. This is the official typed SDK for the Brume REST API — used by the Brume dashboard, server-side cron jobs, and CI/CD pipelines to publish, manage projects, list channels, fetch stats, and rotate API keys.

## Table of Contents

- [Documentation](#documentation)
- [Requirements](#requirements)
- [Installation](#installation)
- [Reference](#reference)
- [Usage](#usage)
- [Errors](#errors)
- [Request Types](#request-types)
- [Advanced](#advanced)
  - [Additional Headers](#additional-headers)
  - [Additional Query String Parameters](#additional-query-string-parameters)
  - [Timeouts](#timeouts)
  - [Custom Networking Client](#custom-networking-client)
- [Contributing](#contributing)

## Documentation

API reference documentation is available [here](https://docs.brume.run).

## Requirements

This SDK requires:
- Swift 5.7+
- iOS 15+
- macOS 12+
- tvOS 15+
- watchOS 8+

## Installation

With Swift Package Manager (SPM), add the following to the top-level `dependencies` array within your `Package.swift` file:

```swift
dependencies: [
    .package(url: "<git-url>", from: "0.1.0"),
]
```

## Reference

A full reference for this library is available [here](./reference.md).

## Usage

Instantiate and use the client with the following:

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

## Errors

The SDK throws a single error enum for all failures. Client-side issues encoding/decoding failures and network errors use dedicated cases, while non-success HTTP responses are wrapped in an `HTTPError` that exposes the status code, a simple classification and an optional decoded message.

```swift
import Brume

let client = BrumeClient(apiKey: "YOUR_API_KEY")

do {
    let response = try await client.apiKeys.createApiKey(...)
    // Handle successful response
} catch let error as BrumeError {
    switch error {
    case .httpError(let httpError):
        print("Status code:", httpError.statusCode)
        print("Kind:", httpError.kind)
        print("Message:", httpError.body?.message ?? httpError.localizedDescription)
    case .encodingError(let underlying):
        print("Encoding error:", underlying)
    case .networkError(let underlying):
        print("Network error:", underlying)
    default:
        print("Other client error:", error)
    }
} catch {
    print("Unexpected error:", error)
}
```

## Request Types

The SDK exports all request types as Swift structs. Simply import the SDK module to access them:

```swift
import Brume

let request = Requests.CreateApiKeyRequest(
    ...
)
```

## Advanced

### Additional Headers

If you would like to send additional headers as part of the request, use the `additionalHeaders` request option.

```swift
try await client.apiKeys.createApiKey(..., requestOptions: .init(
    additionalHeaders: [
        "X-Custom-Header": "custom value"
    ]
))
```

### Additional Query String Parameters

If you would like to send additional query string parameters as part of the request, use the `additionalQueryParameters` request option.

```swift
try await client.apiKeys.createApiKey(..., requestOptions: .init(
    additionalQueryParameters: [
        "custom_query_param_key": "custom_query_param_value"
    ]
))
```

### Timeouts

The SDK defaults to a 60-second timeout. Use the `timeout` option to configure this behavior.

```swift
try await client.apiKeys.createApiKey(..., requestOptions: .init(
    timeout: 30
))
```

### Custom Networking Client

The SDK allows you to customize the underlying `URLSession` used for HTTP requests. Use the `urlSession` option to provide your own configured `URLSession` instance.

```swift
import Foundation
import Brume

let client = BrumeClient(
    apiKey: "YOUR_API_KEY",
    urlSession: // Provide your implementation here
)
```

## Contributing

While we value open-source contributions to this SDK, this library is generated programmatically.
Additions made directly to this library would have to be moved over to our generation code,
otherwise they would be overwritten upon the next generated release. Feel free to open a PR as
a proof of concept, but know that we will not be able to merge it as-is. We suggest opening
an issue first to discuss with us!

On the other hand, contributions to the README are always very welcome!
