using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record WebhookDeliveryItem : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    [JsonPropertyName("attempts")]
    public required int Attempts { get; set; }

    /// <summary>
    /// RFC-3339 timestamp of delivery creation.
    /// </summary>
    [JsonPropertyName("created_at")]
    public required string CreatedAt { get; set; }

    [JsonPropertyName("event_type")]
    public required string EventType { get; set; }

    [JsonPropertyName("id")]
    public required string Id { get; set; }

    /// <summary>
    /// RFC-3339 timestamp of the most recent attempt, or `null`.
    /// </summary>
    [JsonPropertyName("last_attempt_at")]
    public string? LastAttemptAt { get; set; }

    /// <summary>
    /// HTTP status code of the most recent attempt, or `null`.
    /// </summary>
    [JsonPropertyName("response_status")]
    public int? ResponseStatus { get; set; }

    /// <summary>
    /// `"pending" | "delivered" | "failed"`.
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
