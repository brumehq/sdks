namespace Brume.Rest;

/// <summary>
/// This exception type will be thrown for any non-2XX API responses.
/// </summary>
[Serializable]
public class TooManyRequestsError(object body, Brume.Rest.RawResponse? rawResponse = null)
    : BrumeRestClientApiException("TooManyRequestsError", 429, body, rawResponse: rawResponse);
