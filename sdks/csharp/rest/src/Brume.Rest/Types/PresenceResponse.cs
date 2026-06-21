using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `GET /v1/channels/:channel/presence` success response.
/// </summary>
[Serializable]
public record PresenceResponse : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("channel")]
    public required string Channel { get; set; }

    [JsonPropertyName("connection_count")]
    public required int ConnectionCount { get; set; }

    /// <summary>
    /// Connection roster. Empty if presence tracking is disabled or the
    /// channel has no subscribers.
    /// </summary>
    [JsonPropertyName("presence")]
    public IEnumerable<ConnectionInfo> Presence { get; set; } = new List<ConnectionInfo>();

    [JsonIgnore]
    public ReadOnlyAdditionalProperties AdditionalProperties { get; private set; } = new();

    void IJsonOnDeserialized.OnDeserialized() =>
        AdditionalProperties.CopyFromExtensionData(_extensionData);

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
