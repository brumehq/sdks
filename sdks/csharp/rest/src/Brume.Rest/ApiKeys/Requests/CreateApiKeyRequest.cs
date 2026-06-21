using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record CreateApiKeyRequest
{
    /// <summary>
    /// `"live"` or `"test"`. Determines the key prefix
    /// (`pk_live_` vs `pk_test_`) and the default scope set.
    /// </summary>
    [JsonPropertyName("environment")]
    public required string Environment { get; set; }

    /// <summary>
    /// Human-readable label. Shown in the dashboard.
    /// </summary>
    [JsonPropertyName("label")]
    public required string Label { get; set; }

    /// <summary>
    /// Optional explicit scopes. Omit to receive the default scope set
    /// (`publish`, `read_stats`, `manage_keys`).
    /// </summary>
    [JsonPropertyName("scopes")]
    public IEnumerable<ApiKeyScope>? Scopes { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
