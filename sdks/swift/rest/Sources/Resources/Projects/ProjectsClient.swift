import Foundation

public final class ProjectsClient: Sendable {
    private let httpClient: HTTPClient

    init(config: ClientConfig) {
        self.httpClient = HTTPClient(config: config)
    }

    /// Returns full project info for the dashboard.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func getProject(requestOptions: RequestOptions? = nil) async throws -> ProjectResponse {
        return try await httpClient.performRequest(
            method: .get,
            path: "/v1/project",
            requestOptions: requestOptions,
            responseType: ProjectResponse.self
        )
    }

    /// Creates a new project with an initial API key. Gated on email verification.
    ///
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func createProject(request: Requests.CreateProjectRequest, requestOptions: RequestOptions? = nil) async throws -> CreateProjectResponse {
        return try await httpClient.performRequest(
            method: .post,
            path: "/v1/projects",
            body: request,
            requestOptions: requestOptions,
            responseType: CreateProjectResponse.self
        )
    }

    /// Internal sync endpoint used by the dashboard after Polar.sh webhook
    /// processing. Gated by `BRUME_INTERNAL_TOKEN`.
    ///
    /// - Parameter id: Hex-encoded project id (16 bytes → 32 hex chars).
    /// - Parameter requestOptions: Additional options for configuring the request, such as custom headers or timeout settings.
    public func updateProjectTier(id: String, request: Requests.UpdateProjectTierRequest, requestOptions: RequestOptions? = nil) async throws -> UpdateProjectTierResponse {
        return try await httpClient.performRequest(
            method: .patch,
            path: "/v1/projects/\(id)/tier",
            body: request,
            requestOptions: requestOptions,
            responseType: UpdateProjectTierResponse.self
        )
    }
}