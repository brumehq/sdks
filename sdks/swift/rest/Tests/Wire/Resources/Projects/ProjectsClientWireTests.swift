import Foundation
import Testing
import Brume

@Suite("ProjectsClient Wire Tests") struct ProjectsClientWireTests {
    @Test func getProject1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "created_at": "created_at",
                  "id": "id",
                  "max_connections": 1000000,
                  "name": "name",
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = ProjectResponse(
            createdAt: "created_at",
            id: "id",
            maxConnections: 1000000,
            name: "name",
            tier: "tier"
        )
        let response = try await client.projects.getProject(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func getProject2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "created_at": "created_at",
                  "id": "id",
                  "max_connections": 1000000,
                  "name": "name",
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = ProjectResponse(
            createdAt: "created_at",
            id: "id",
            maxConnections: 1000000,
            name: "name",
            tier: "tier"
        )
        let response = try await client.projects.getProject(requestOptions: RequestOptions(additionalHeaders: stub.headers))
        try #require(response == expectedResponse)
    }

    @Test func createProject1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "api_key": "api_key",
                  "id": "id",
                  "max_connections": 1000000,
                  "name": "name",
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = CreateProjectResponse(
            apiKey: "api_key",
            id: "id",
            maxConnections: 1000000,
            name: "name",
            tier: "tier"
        )
        let response = try await client.projects.createProject(
            request: .init(name: "name"),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func createProject2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "api_key": "api_key",
                  "id": "id",
                  "max_connections": 1000000,
                  "name": "name",
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = CreateProjectResponse(
            apiKey: "api_key",
            id: "id",
            maxConnections: 1000000,
            name: "name",
            tier: "tier"
        )
        let response = try await client.projects.createProject(
            request: .init(name: "name"),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func updateProjectTier1() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "id": "id",
                  "max_connections": 1000000,
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = UpdateProjectTierResponse(
            id: "id",
            maxConnections: 1000000,
            tier: "tier"
        )
        let response = try await client.projects.updateProjectTier(
            id: "id",
            request: .init(tier: "tier"),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }

    @Test func updateProjectTier2() async throws -> Void {
        let stub = HTTPStub()
        stub.setResponse(
            body: Foundation.Data(
                #"""
                {
                  "id": "id",
                  "max_connections": 1000000,
                  "tier": "tier"
                }
                """#.utf8
            )
        )
        let client = BrumeClient(
            baseURL: "https://api.fern.com",
            apiKey: "<token>",
            urlSession: stub.urlSession
        )
        let expectedResponse = UpdateProjectTierResponse(
            id: "id",
            maxConnections: 1000000,
            tier: "tier"
        )
        let response = try await client.projects.updateProjectTier(
            id: "id",
            request: .init(tier: "tier"),
            requestOptions: RequestOptions(additionalHeaders: stub.headers)
        )
        try #require(response == expectedResponse)
    }
}