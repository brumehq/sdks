namespace Brume.Rest;

public partial interface IProjectsClient
{
    /// <summary>
    /// Returns full project info for the dashboard.
    /// </summary>
    WithRawResponseTask<ProjectResponse> GetProjectAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Creates a new project with an initial API key. Gated on email verification.
    /// </summary>
    WithRawResponseTask<CreateProjectResponse> CreateProjectAsync(
        CreateProjectRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    /// <summary>
    /// Internal sync endpoint used by the dashboard after Polar.sh webhook
    /// processing. Gated by `BRUME_INTERNAL_TOKEN`.
    /// </summary>
    WithRawResponseTask<UpdateProjectTierResponse> UpdateProjectTierAsync(
        string id,
        UpdateProjectTierRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
