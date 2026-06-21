using Brume.Rest.Core;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[Serializable]
public record AnalyticsRequest
{
    /// <summary>
    /// Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
    /// </summary>
    [JsonIgnore]
    public long? WindowSecs { get; set; }

    /// <inheritdoc />
    public override string ToString()
    {
        return JsonUtils.Serialize(this);
    }
}
