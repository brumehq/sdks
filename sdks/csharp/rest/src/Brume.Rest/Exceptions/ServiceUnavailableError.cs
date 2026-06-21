namespace Brume.Rest;

/// <summary>
/// This exception type will be thrown for any non-2XX API responses.
/// </summary>
[Serializable]
public class ServiceUnavailableError(object body, Brume.Rest.RawResponse? rawResponse = null)
    : BrumeRestClientApiException("ServiceUnavailableError", 503, body, rawResponse: rawResponse);
