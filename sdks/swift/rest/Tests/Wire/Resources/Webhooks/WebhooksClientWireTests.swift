import Foundation
import Testing
import Brume

@Suite("WebhooksClient Wire Tests") struct WebhooksClientWireTests {
    @Test func list1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "webhooks": [
                    {
                      "created_at": "created_at",
                      "events": [
                        "events"
                      ],
                      "id": "id",
                      "url": "url"
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
        let expectedResponse = WebhookListResponse(
            webhooks: [
                WebhookSummary(
                    createdAt: "created_at",
                    events: [
                        "events"
                    ],
                    id: "id",
                    url: "url"
                )
            ]
        )
        let response = try await client.webhooks.list(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func list2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "webhooks": [
                    {
                      "created_at": "created_at",
                      "events": [
                        "events",
                        "events"
                      ],
                      "id": "id",
                      "url": "url"
                    },
                    {
                      "created_at": "created_at",
                      "events": [
                        "events",
                        "events"
                      ],
                      "id": "id",
                      "url": "url"
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
        let expectedResponse = WebhookListResponse(
            webhooks: [
                WebhookSummary(
                    createdAt: "created_at",
                    events: [
                        "events",
                        "events"
                    ],
                    id: "id",
                    url: "url"
                ),
                WebhookSummary(
                    createdAt: "created_at",
                    events: [
                        "events",
                        "events"
                    ],
                    id: "id",
                    url: "url"
                )
            ]
        )
        let response = try await client.webhooks.list(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func create1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "events": [
                    "events"
                  ],
                  "id": "id",
                  "secret": "secret",
                  "url": "url"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = WebhookCreatedResponse(
            events: [
                "events"
            ],
            id: "id",
            secret: "secret",
            url: "url"
        )
        let response = try await client.webhooks.create(
            request: .init(
                events: [
                    "events"
                ],
                url: "url"
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func create2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "events": [
                    "events",
                    "events"
                  ],
                  "id": "id",
                  "secret": "secret",
                  "url": "url"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = WebhookCreatedResponse(
            events: [
                "events",
                "events"
            ],
            id: "id",
            secret: "secret",
            url: "url"
        )
        let response = try await client.webhooks.create(
            request: .init(
                events: [
                    "events",
                    "events"
                ],
                url: "url"
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func delete1() async throws -> Void {
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
        let expectedResponse = WebhookDeleteResponse(
            status: "status"
        )
        let response = try await client.webhooks.delete(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func delete2() async throws -> Void {
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
        let expectedResponse = WebhookDeleteResponse(
            status: "status"
        )
        let response = try await client.webhooks.delete(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func listDeliveries1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "deliveries": [
                    {
                      "attempts": 1,
                      "created_at": "created_at",
                      "event_type": "event_type",
                      "id": "id",
                      "last_attempt_at": "last_attempt_at",
                      "response_status": 1,
                      "status": "status"
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
        let expectedResponse = WebhookDeliveryListResponse(
            deliveries: [
                WebhookDeliveryItem(
                    attempts: 1,
                    createdAt: "created_at",
                    eventType: "event_type",
                    id: "id",
                    lastAttemptAt: Optional("last_attempt_at"),
                    responseStatus: Optional(1),
                    status: "status"
                )
            ]
        )
        let response = try await client.webhooks.listDeliveries(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func listDeliveries2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "deliveries": [
                    {
                      "attempts": 1,
                      "created_at": "created_at",
                      "event_type": "event_type",
                      "id": "id",
                      "last_attempt_at": "last_attempt_at",
                      "response_status": 1,
                      "status": "status"
                    },
                    {
                      "attempts": 1,
                      "created_at": "created_at",
                      "event_type": "event_type",
                      "id": "id",
                      "last_attempt_at": "last_attempt_at",
                      "response_status": 1,
                      "status": "status"
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
        let expectedResponse = WebhookDeliveryListResponse(
            deliveries: [
                WebhookDeliveryItem(
                    attempts: 1,
                    createdAt: "created_at",
                    eventType: "event_type",
                    id: "id",
                    lastAttemptAt: Optional("last_attempt_at"),
                    responseStatus: Optional(1),
                    status: "status"
                ),
                WebhookDeliveryItem(
                    attempts: 1,
                    createdAt: "created_at",
                    eventType: "event_type",
                    id: "id",
                    lastAttemptAt: Optional("last_attempt_at"),
                    responseStatus: Optional(1),
                    status: "status"
                )
            ]
        )
        let response = try await client.webhooks.listDeliveries(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func test1() async throws -> Void {
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
        let expectedResponse = WebhookTestResponse(
            status: "status"
        )
        let response = try await client.webhooks.test(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func test2() async throws -> Void {
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
        let expectedResponse = WebhookTestResponse(
            status: "status"
        )
        let response = try await client.webhooks.test(
            id: "id",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }
}