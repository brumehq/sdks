# Brume SDKs

All official Brume Realtime Gateway SDKs across every supported language, generated and published from a single source.

Source: [brumehq/brume](https://github.com/brumehq/brume) (private).
This repo is populated by a CI workflow that runs in the private monorepo. See [brumehq/brume](https://github.com/brumehq/brume) for the source of truth and the build pipeline.

## Layout

```
sdks/
├── typescript/        npm
│   ├── rest/          @brume/rest          (Fern-generated REST client)
│   ├── client/        @brume/client        (hand-written WebSocket client)
│   ├── server/        @brume/server        (hand-written JWT gen + REST helpers)
│   ├── react/         @brume/react         (hand-written React hooks)
│   ├── protocol/      @brume/protocol      (hand-written shared protocol types)
│   └── testing/       @brume/testing       (hand-written mock server)
├── python/            PyPI
│   └── rest/          brume                (Fern-generated)
├── go/                Go modules
│   └── rest/          github.com/brumehq/brume-rest-go
├── java/              Maven Central
│   └── rest/          dev.brume:brume-rest
├── csharp/            NuGet
│   └── rest/          Brume.Rest
├── php/               Composer
│   └── rest/          brume/brume-rest
├── ruby/              RubyGems
│   └── rest/          brume-rest
├── swift/             Swift Package Manager
│   └── rest/          Brume
└── rust/              crates.io
    └── rest/          brume-rest
```

## Install

Pick your language and follow the link to the package directory for the full README and version-specific install instructions.

### TypeScript / JavaScript

```sh
# REST client (generated from the OpenAPI spec)
npm install @brume/rest

# WebSocket client (hand-written, full envelope support)
npm install @brume/client

# Server-side JWT signing + REST publish helper
npm install @brume/server

# React hooks built on @brume/client
npm install @brume/react
```

### Python

```sh
pip install brume
```

### Go

```sh
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

```sh
dotnet add package Brume.Rest
```

### PHP

```sh
composer require brume/brume-rest
```

### Ruby

```ruby
# Gemfile
gem "brume-rest"
```

### Swift

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/brumehq/brume-rest-swift", from: "0.1.0"),
]
```

### Rust

```sh
cargo add brume-rest
```

## How this repo is updated

This repo is **a build artifact**, not a source of truth. All edits happen in [brumehq/brume](https://github.com/brumehq/brume):

- **Hand-written packages** (`@brume/client`, `@brume/server`, etc.) — edit in `brumehq/brume/packages/<name>/` and open a PR there. The CI copies the rendered source into this repo on merge.
- **Fern-generated SDKs** (the `rest/` package in every language) — edit the Rust handler in `brumehq/brume/crates/core/`, or the `fern/generators.yml` config. The CI regenerates and pushes the new SDKs here.

Direct pushes to `main` of this repo are allowed for emergency hotfixes (and the fix must also land in `brumehq/brume` to persist across the next CI run).

## License

MIT. See [LICENSE](./LICENSE) for details.
