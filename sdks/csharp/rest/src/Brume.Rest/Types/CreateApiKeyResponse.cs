using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `POST /v1/api-keys` success response. The `key` field is the raw
/// key returned exactly once; clients must store it before navigating
/// away.
/// </summary>
[Serializable]
public record CreateApiKeyResponse : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("environment")]
    public required string Environment { get; set; }

    /// <summary>
    /// Hex-encoded key id.
    /// </summary>
    [JsonPropertyName("id")]
    public required string Id { get; set; }

    /// <summary>
    /// The raw API key. Only returned by the create endpoint.
    /// </summary>
    [JsonPropertyName("key")]
    public required string Key { get; set; }

    [JsonPropertyName("label")]
    public required string Label { get; set; }

    /// <summary>
    /// 28-char prefix used for O(1) lookup. Safe to display.
    /// </summary>
    [JsonPropertyName("prefix")]
    public required string Prefix { get; set; }

    /// <summary>
    /// Granted scopes (E6). Serializes as the snake_case string form
    /// (`"publish"`, `"read_stats"`, `"manage_keys"`, `"manage_project"`).
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
