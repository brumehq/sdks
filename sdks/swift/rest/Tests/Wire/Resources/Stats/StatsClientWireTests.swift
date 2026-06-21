import Foundation
import Testing
import Brume

@Suite("StatsClient Wire Tests") struct StatsClientWireTests {
    @Test func analytics1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "generated_at": "2026-06-20T00:00:00Z",
                  "interval_seconds": 30,
                  "snapshots": {
                    "key": "value"
                  },
                  "window_seconds": 3600
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = [
            "generated_at": JSONValue.string("2026-06-20T00:00:00Z"), 
            "interval_seconds": JSONValue.number(30), 
            "snapshots": JSONValue.object(
                [
                    "key": JSONValue.string("value")
                ]
            ), 
            "window_seconds": JSONValue.number(3600)
        ]
        let response = try await client.stats.analytics(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func analytics2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "string": {
                    "key": "value"
                  }
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = [
            "string": JSONValue.object(
                [
                    "key": JSONValue.string("value")
                ]
            )
        ]
        let response = try await client.stats.analytics(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func getStats1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "dropped_messages": 0,
                  "global": {
                    "channels": 5,
                    "connections": 12
                  },
                  "latency": {
                    "p50": 42,
                    "p95": 80,
                    "p99": 120
                  },
                  "postgres_lag": {
                    "enabled": false
                  },
                  "project": {
                    "channels": 2,
                    "connections": 7,
                    "id": "abcdef01",
                    "tier": "pro"
                  },
                  "top_channels": {
                    "key": "value"
                  }
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = [
            "dropped_messages": JSONValue.number(0), 
            "global": JSONValue.object(
                [
                    "channels": JSONValue.number(5), 
                    "connections": JSONValue.number(12)
                ]
            ), 
            "latency": JSONValue.object(
                [
                    "p50": JSONValue.number(42), 
                    "p95": JSONValue.number(80), 
                    "p99": JSONValue.number(120)
                ]
            ), 
            "postgres_lag": JSONValue.object(
                [
                    "enabled": JSONValue.bool(false)
                ]
            ), 
            "project": JSONValue.object(
                [
                    "channels": JSONValue.number(2), 
                    "connections": JSONValue.number(7), 
                    "id": JSONValue.string("abcdef01"), 
                    "tier": JSONValue.string("pro")
                ]
            ), 
            "top_channels": JSONValue.object(
                [
                    "key": JSONValue.string("value")
                ]
            )
        ]
        let response = try await client.stats.getStats(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func getStats2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "string": {
                    "key": "value"
                  }
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = [
            "string": JSONValue.object(
                [
                    "key": JSONValue.string("value")
                ]
            )
        ]
        let response = try await client.stats.getStats(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }
}