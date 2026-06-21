using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `POST /v1/projects` success response. The `api_key` field is the only
/// time the raw key is returned; clients must store it immediately.
/// </summary>
[Serializable]
public record CreateProjectResponse : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    /// <summary>
    /// The raw API key. `null` after the first call (the server does
    /// not retain plaintext keys).
    /// </summary>
    [JsonPropertyName("api_key")]
    public required string ApiKey { get; set; }

    /// <summary>
    /// Hex-encoded 16-byte project id.
    /// </summary>
    [JsonPropertyName("id")]
    public required string Id { get; set; }

    [JsonPropertyName("max_connections")]
    public required long MaxConnections { get; set; }

    [JsonPropertyName("name")]
    public required string Name { get; set; }

    [JsonPropertyName("tier")]
    public required string Tier { get; set; }

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
