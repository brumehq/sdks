namespace Brume.Rest;

/// <summary>
/// This exception type will be thrown for any non-2XX API responses.
/// </summary>
[Serializable]
public class BadRequestError(object body, Brume.Rest.RawResponse? rawResponse = null)
    : BrumeRestClientApiException("BadRequestError", 400, body, rawResponse: rawResponse);
