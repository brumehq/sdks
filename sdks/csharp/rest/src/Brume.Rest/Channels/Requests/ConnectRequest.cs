using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record ConnectRequest
{
    /// <summary>
    /// Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.&lt;jwt&gt;` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
    /// </summary>
    [JsonIgnore]
    public string? Token { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
