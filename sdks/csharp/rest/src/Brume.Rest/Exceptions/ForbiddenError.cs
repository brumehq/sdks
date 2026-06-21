namespace Brume.Rest;

/// <summary>
/// This exception type will be thrown for any non-2XX API responses.
/// </summary>
[Serializable]
public class ForbiddenError(ErrorBody body, Brume.Rest.RawResponse? rawResponse = null)
    : BrumeRestClientApiException("ForbiddenError", 403, body, rawResponse: rawResponse)
{
    /// <summary>
    /// The body of the response that triggered the exception.
    /// </summary>
    public new ErrorBody Body => body;
}
