using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// Standard error response body returned by all REST endpoints on 4xx/5xx.
///
/// The legacy handlers emit `{"error": "..."}` (string-only). The newer
/// handlers emit `{"error": "CODE", "message": "human-readable"}`. Both
/// shapes parse into this struct; the `message` field is optional for
/// back-compat.
/// </summary>
[Serializable]
public record ErrorBody : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    /// <summary>
    /// Short error code. Either a stable machine code (`AUTH_INVALID`,
    /// `RATE_LIMITED`, `EMAIL_NOT_VERIFIED`, etc.) or a free-form string
    /// for legacy handlers. SDK consumers should pattern-match the
    /// well-known codes and treat unknown values as opaque failures.
    /// </summary>
    [JsonPropertyName("error")]
    public required string Error { get; set; }

    /// <summary>
    /// Human-readable description. Absent on legacy string-only errors.
    /// </summary>
    [JsonPropertyName("message")]
    public string? Message { get; set; }

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
