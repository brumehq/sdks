using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record ConnectionInfo : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("state")]
    public required object State { get; set; }

    /// <summary>
    /// RFC-3339 timestamp of the last presence update.
    /// </summary>
    [JsonPropertyName("updated_at")]
    public required string UpdatedAt { get; set; }

    [JsonPropertyName("user_id")]
    public required string UserId { get; set; }

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
