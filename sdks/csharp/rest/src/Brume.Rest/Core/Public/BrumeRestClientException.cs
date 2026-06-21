namespace Brume.Rest;

/// <summary>
/// Base exception class for all exceptions thrown by the SDK.
/// </summary>
public class BrumeRestClientException(string message, Exception? innerException = null)
    : Exception(message, innerException);
