using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record ApiKeyListItem : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("environment")]
    public required string Environment { get; set; }

    [JsonPropertyName("id")]
    public required string Id { get; set; }

    [JsonPropertyName("label")]
    public required string Label { get; set; }

    /// <summary>
    /// RFC-3339 timestamp of last use, or `null` if never used.
    /// </summary>
    [JsonPropertyName("last_used_at")]
    public string? LastUsedAt { get; set; }

    [JsonPropertyName("prefix")]
    public required string Prefix { get; set; }

    /// <summary>
    /// Granted scopes (E6). Serializes as snake_case strings.
    /// </summary>
    [JsonPropertyName("scopes")]
    public IEnumerable<ApiKeyScope> Scopes { get; set; } = new List<ApiKeyScope>();

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
