namespace Brume.Rest;

/// <summary>
/// This exception type will be thrown for any non-2XX API responses.
/// </summary>
[Serializable]
public class UnauthorizedError(ErrorBody body, Brume.Rest.RawResponse? rawResponse = null)
    : BrumeRestClientApiException("UnauthorizedError", 401, body, rawResponse: rawResponse)
{
    /// <summary>
    /// The body of the response that triggered the exception.
    /// </summary>
    public new ErrorBody Body => body;
}
