import Foundation
import Testing
import Brume

@Suite("ChannelsClient Wire Tests") struct ChannelsClientWireTests {
    @Test func listChannels1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channels": [
                    {
                      "id": "id",
                      "name": "name"
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
        let expectedResponse = ChannelListResponse(
            channels: [
                ChannelSummary(
                    id: "id",
                    name: "name"
                )
            ]
        )
        let response = try await client.channels.listChannels(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func listChannels2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channels": [
                    {
                      "id": "id",
                      "name": "name"
                    },
                    {
                      "id": "id",
                      "name": "name"
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
        let expectedResponse = ChannelListResponse(
            channels: [
                ChannelSummary(
                    id: "id",
                    name: "name"
                ),
                ChannelSummary(
                    id: "id",
                    name: "name"
                )
            ]
        )
        let response = try await client.channels.listChannels(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func getPresence1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channel": "channel",
                  "connection_count": 1,
                  "presence": [
                    {
                      "state": {
                        "key": "value"
                      },
                      "updated_at": "updated_at",
                      "user_id": "user_id"
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
        let expectedResponse = PresenceResponse(
            channel: "channel",
            connectionCount: 1,
            presence: [
                ConnectionInfo(
                    state: JSONValue.object(
                        [
                            "key": JSONValue.string("value")
                        ]
                    ),
                    updatedAt: "updated_at",
                    userId: "user_id"
                )
            ]
        )
        let response = try await client.channels.getPresence(
            channel: "channel",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func getPresence2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channel": "channel",
                  "connection_count": 1,
                  "presence": [
                    {
                      "state": {
                        "key": "value"
                      },
                      "updated_at": "updated_at",
                      "user_id": "user_id"
                    },
                    {
                      "state": {
                        "key": "value"
                      },
                      "updated_at": "updated_at",
                      "user_id": "user_id"
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
        let expectedResponse = PresenceResponse(
            channel: "channel",
            connectionCount: 1,
            presence: [
                ConnectionInfo(
                    state: JSONValue.object(
                        [
                            "key": JSONValue.string("value")
                        ]
                    ),
                    updatedAt: "updated_at",
                    userId: "user_id"
                ),
                ConnectionInfo(
                    state: JSONValue.object(
                        [
                            "key": JSONValue.string("value")
                        ]
                    ),
                    updatedAt: "updated_at",
                    userId: "user_id"
                )
            ]
        )
        let response = try await client.channels.getPresence(
            channel: "channel",
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func publish1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channel": "channel",
                  "event": "event",
                  "recipients": 1,
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
        let expectedResponse = PublishResponse(
            channel: "channel",
            event: "event",
            recipients: 1,
            status: "status"
        )
        let response = try await client.channels.publish(
            channel: "channel",
            request: .init(
                event: "event",
                payload: [
                    "key": .string("value")
                ]
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func publish2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "channel": "channel",
                  "event": "event",
                  "recipients": 1,
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
        let expectedResponse = PublishResponse(
            channel: "channel",
            event: "event",
            recipients: 1,
            status: "status"
        )
        let response = try await client.channels.publish(
            channel: "channel",
            request: .init(
                event: "event",
                payload: [
                    "payload": .object([
                        "key": .string("value")
                    ])
                ]
            ),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }
}