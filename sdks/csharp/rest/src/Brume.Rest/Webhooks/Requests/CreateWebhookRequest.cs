using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record CreateWebhookRequest
{
    /// <summary>
    /// Event names to subscribe to (e.g. `["channel.message.published"]`).
    /// </summary>
    [JsonPropertyName("events")]
    public IEnumerable<string> Events { get; set; } = new List<string>();

    /// <summary>
    /// Destination URL. Validated by `webhook_validation::validate_webhook_url`.
    /// </summary>
    [JsonPropertyName("url")]
    public required string Url { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
