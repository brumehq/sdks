# Brume SDKs

All Brume Realtime Gateway SDKs across languages, in one place.

Source of truth: [`brumehq/brume`](https://github.com/brumehq/brume) (private). This repo is populated by CI; for hand-written packages (`@brume/client`, `@brume/server`, etc.), PRs land in the source repo and the CI copies them here.

## Layout

```
sdks/
├── typescript/
│   ├── rest/         @brume/rest          (Fern-generated REST client)
│   ├── client/       @brume/client        (hand-written WebSocket client)
│   ├── server/       @brume/server        (hand-written JWT + REST helpers)
│   ├── react/        @brume/react         (hand-written React hooks)
│   ├── protocol/     @brume/protocol      (hand-written shared types)
│   └── testing/      @brume/testing       (hand-written mock server)
├── python/rest/      brume                (Fern-generated)
├── go/rest/          github.com/brumehq/brume-rest-go  (Fern-generated)
├── java/rest/        dev.brume:brume-rest             (Fern-generated)
├── csharp/rest/      Brume.Rest                       (Fern-generated)
├── php/rest/         brume/brume-rest                 (Fern-generated)
├── ruby/rest/        brume-rest gem                   (Fern-generated)
├── swift/rest/       Brume                            (Fern-generated)
└── rust/rest/        brume-rest crate                 (Fern-generated)
```

## Install

### TypeScript / JavaScript

```bash
# REST client (typed)
npm install @brume/rest
# or
pnpm add @brume/rest
# or
bun add @brume/rest

# WebSocket client
npm install @brume/client

# JWT generation (server-side)
npm install @brume/server

# React hooks
npm install @brume/react

# Protocol types (peer dep of @brume/client)
npm install @brume/protocol

# Mock server for tests
npm install --save-dev @brume/testing
```

### Python

```bash
pip install brume
```

### Go

```bash
go get github.com/brumehq/brume-rest-go
```

### Java / Kotlin

```xml
<dependency>
    <groupId>dev.brume</groupId>
    <artifactId>brume-rest</artifactId>
    <version>0.1.0</version>
</dependency>
```

### C# / .NET

```bash
dotnet add package Brume.Rest
```

### PHP

```bash
composer require brume/brume-rest
```

### Ruby

```bash
gem install brume-rest
```

### Swift (SPM)

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/brumehq/brume-rest-swift", from: "0.1.0"),
]
```

### Rust

```bash
cargo add brume-rest
```

## Authentication

Every SDK reads the API key from the `BRUME_API_KEY` environment variable. You can also pass it explicitly to the client constructor.

```ts
// TypeScript
import { BrumeClient } from "@brume/rest";
const client = new BrumeClient({ apiKey: process.env.BRUME_API_KEY });
```

```python
import os
from brume import BrumeClient
client = BrumeClient(api_key=os.environ["BRUME_API_KEY"])
```

```go
import "os"
import brume "github.com/brumehq/brume-rest-go"
client := brume.NewClient( brume.WithToken(os.Getenv("BRUME_API_KEY")) )
```

## Documentation

- API reference: <https://docs.brume.run>
- Brume docs: <https://docs.brume.run>
- WebSocket protocol: see the `@brume/client` README in [`sdks/typescript/client/`](./sdks/typescript/client/)

## Contributing

Hand-written TS packages (`@brume/client`, `@brume/server`, `@brume/react`, `@brume/protocol`, `@brume/testing`) live in [`brumehq/brume`](https://github.com/brumehq/brume). Open a PR there. The CI in that repo will copy the change into this repo.

The Rust core and Fern config also live in `brumehq/brume`. Changes to the OpenAPI spec or `fern/generators.yml` trigger a regeneration of the 9 Fern-generated SDKs in this repo.

## License

MIT — see each package's `LICENSE` file.
