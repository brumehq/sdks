using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record PublishRequest
{
    /// <summary>
    /// Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
    /// Must NOT start with `brume:` (reserved for system events).
    /// </summary>
    [JsonPropertyName("event")]
    public required string Event { get; set; }

    /// <summary>
    /// Free-form JSON payload delivered to subscribers.
    /// </summary>
    [JsonPropertyName("payload")]
    public Dictionary<string, object?> Payload { get; set; } = new Dictionary<string, object?>();

    /// <summary>
    /// Optional client-generated idempotency key. Echoed in `brume:ack`.
    /// </summary>
    [JsonPropertyName("ref")]
    public string? Ref { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
