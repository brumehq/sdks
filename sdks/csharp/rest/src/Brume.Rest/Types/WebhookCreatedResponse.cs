using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `POST /v1/webhooks` success response. Includes the `secret` field
/// which is only returned at creation time.
/// </summary>
[Serializable]
public record WebhookCreatedResponse : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("events")]
    public IEnumerable<string> Events { get; set; } = new List<string>();

    [JsonPropertyName("id")]
    public required string Id { get; set; }

    /// <summary>
    /// HMAC-SHA256 secret used to sign deliveries. Only returned once.
    /// </summary>
    [JsonPropertyName("secret")]
    public required string Secret { get; set; }

    [JsonPropertyName("url")]
    public required string Url { get; set; }

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
