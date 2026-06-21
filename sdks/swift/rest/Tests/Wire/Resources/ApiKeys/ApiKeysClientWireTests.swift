import Foundation
import Testing
import Brume

@Suite("ApiKeysClient Wire Tests") struct ApiKeysClientWireTests {
    @Test func listApiKeys1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "api_keys": [
                    {
                      "environment": "environment",
                      "id": "id",
                      "label": "label",
                      "last_used_at": "last_used_at",
                      "prefix": "prefix",
                      "scopes": [
                        "publish"
                      ]
                    }
                  ]
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = ApiKeyListResponse(
            apiKeys: [
                ApiKeyListItem(
                    environment: "environment",
                    id: "id",
                    label: "label",
                    lastUsedAt: Optional("last_used_at"),
                    prefix: "prefix",
                    scopes: [
                        .publish
                    ]
                )
            ]
        )
        let response = try await client.apiKeys.listApiKeys(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func listApiKeys2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "api_keys": [
                    {
                      "environment": "environment",
                      "id": "id",
                      "label": "label",
                      "last_used_at": "last_used_at",
                      "prefix": "prefix",
                      "scopes": [
                        "publish",
                        "publish"
                      ]
                    },
                    {
                      "environment": "environment",
                      "id": "id",
                      "label": "label",
                      "last_used_at": "last_used_at",
                      "prefix": "prefix",
                      "scopes": [
                        "publish",
                        "publish"
                      ]
                    }
                  ]
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = ApiKeyListResponse(
            apiKeys: [
                ApiKeyListItem(
                    environment: "environment",
                    id: "id",
                    label: "label",
                    lastUsedAt: Optional("last_used_at"),
                    prefix: "prefix",
                    scopes: [
                        .publish,
                        .publish
                    ]
                ),
                ApiKeyListItem(
                    environment: "environment",
                    id: "id",
                    label: "label",
                    lastUsedAt: Optional("last_used_at"),
                    prefix: "prefix",
                    scopes: [
                        .publish,
                        .publish
                    ]
                )
            ]
        )
        let response = try await client.apiKeys.listApiKeys(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func createApiKey1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "environment": "environment",
                  "id": "id",
                  "key": "key",
                  "label": "label",
                  "prefix": "prefix",
                  "scopes": [
                    "publish"
                  ]
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = CreateApiKeyResponse(
            environment: "environment",
            id: "id",
            key: "key",
            label: "label",
            prefix: "prefix",
            scopes: [
                .publish
            ]
        )
        let response = try await client.apiKeys.createApiKey(
            request: .init(
                environment: "environment",
                label: "label"
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func createApiKey2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "environment": "environment",
                  "id": "id",
                  "key": "key",
                  "label": "label",
                  "prefix": "prefix",
                  "scopes": [
                    "publish",
                    "publish"
                  ]
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = CreateApiKeyResponse(
            environment: "environment",
            id: "id",
            key: "key",
            label: "label",
            prefix: "prefix",
            scopes: [
                .publish,
                .publish
            ]
        )
        let response = try await client.apiKeys.createApiKey(
            request: .init(
                environment: "environment",
                label: "label"
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func revokeApiKey1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "status": "status"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = RevokeApiKeyResponse(
            status: "status"
        )
        let response = try await client.apiKeys.revokeApiKey(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func revokeApiKey2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "status": "status"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = RevokeApiKeyResponse(
            status: "status"
        )
        let response = try await client.apiKeys.revokeApiKey(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }
}