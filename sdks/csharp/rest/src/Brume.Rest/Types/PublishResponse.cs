using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `POST /v1/channels/:channel/publish` success response.
/// </summary>
[Serializable]
public record PublishResponse : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("channel")]
    public required string Channel { get; set; }

    [JsonPropertyName("event")]
    public required string Event { get; set; }

    /// <summary>
    /// Number of subscribers the message was fanned out to.
    /// </summary>
    [JsonPropertyName("recipients")]
    public required int Recipients { get; set; }

    /// <summary>
    /// Always `"published"`. Reserved for future state changes.
    /// </summary>
    [JsonPropertyName("status")]
    public required string Status { get; set; }

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
