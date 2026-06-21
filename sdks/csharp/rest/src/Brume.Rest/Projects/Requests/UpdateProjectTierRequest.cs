using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record UpdateProjectTierRequest
{
    /// <summary>
    /// One of `"free" | "starter" | "pro" | "business"`.
    /// </summary>
    [JsonPropertyName("tier")]
    public required string Tier { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
