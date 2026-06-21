using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

/// <summary>
/// `PLAN_LIMIT` error body. Emitted by the publish / create-project /
/// create-key / SSE / long-poll paths when the project hits a per-axis
/// cap. The `code` is always `"PLAN_LIMIT"`; the `reason` is a closed
/// enum string SDK consumers can pattern-match on.
/// </summary>
[Serializable]
public record PlanLimitErrorBody : IJsonOnDeserialized
{
    [JsonExtensionData]
    private readonly IDictionary<string, JsonElement> _extensionData =
        new Dictionary<string, JsonElement>();

    /// <summary>
    /// Always `"PLAN_LIMIT"`.
    /// </summary>
    [JsonPropertyName("code")]
    public required string Code { get; set; }

    /// <summary>
    /// Current count for the axis that triggered the limit.
    /// </summary>
    [JsonPropertyName("current")]
    public required int Current { get; set; }

    /// <summary>
    /// The cap value, or `null` for unlimited (e.g. business tier
    /// connection cap).
    /// </summary>
    [JsonPropertyName("limit")]
    public int? Limit { get; set; }

    /// <summary>
    /// Human-readable message. Includes the current/limit numbers
    /// and the upgrade suggestion.
    /// </summary>
    [JsonPropertyName("message")]
    public required string Message { get; set; }

    /// <summary>
    /// The closed-set reason. See `PlanLimitReason` in
    /// `channels/types.rs` for the full list.
    /// </summary>
    [JsonPropertyName("reason")]
    public required string Reason { get; set; }

    /// <summary>
    /// The next tier up the ladder that lifts this axis, or `null`
    /// when the customer is already on business.
    /// </summary>
    [JsonPropertyName("upgradeTier")]
    public string? UpgradeTier { get; set; }

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
