using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record CreateProjectRequest
{
    /// <summary>
    /// 1-128 chars.
    /// </summary>
    [JsonPropertyName("name")]
    public required string Name { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
