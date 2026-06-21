using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[JsonConverter(typeof(ApiKeyScope.ApiKeyScopeSerializer))]
[Serializable]
public readonly record struct ApiKeyScope : IStringEnum
{
    public static readonly ApiKeyScope Publish = new(Values.Publish);

    public static readonly ApiKeyScope ReadStats = new(Values.ReadStats);

    public static readonly ApiKeyScope ManageKeys = new(Values.ManageKeys);

    public static readonly ApiKeyScope ManageProject = new(Values.ManageProject);

    public ApiKeyScope(string value)
    {
        Value = value;
    }

    /// <summary>
    /// The string value of the enum.
    /// </summary>
    public string Value { get; }

    /// <summary>
    /// Create a string enum with the given value.
    /// </summary>
    public static ApiKeyScope FromCustom(string value)
    {
        return new ApiKeyScope(value);
    }

    public bool Equals(string? other)
    {
        return Value.Equals(other);
    }

    /// <summary>
    /// Returns the string value of the enum.
    /// </summary>
    public override string ToString()
    {
        return Value;
    }

    public static bool operator ==(ApiKeyScope value1, string value2) =>
        value1.Value.Equals(value2);

    public static bool operator !=(ApiKeyScope value1, string value2) =>
        !value1.Value.Equals(value2);

    public static explicit operator string(ApiKeyScope value) => value.Value;

    public static explicit operator ApiKeyScope(string value) => new(value);

    internal class ApiKeyScopeSerializer : JsonConverter<ApiKeyScope>
    {
        public override ApiKeyScope Read(
            ref Utf8JsonReader reader,
            Type typeToConvert,
            JsonSerializerOptions options
        )
        {
            var stringValue =
                reader.GetString()
                ?? throw new global::System.Exception(
                    "The JSON value could not be read as a string."
                );
            return new ApiKeyScope(stringValue);
        }

        public override void Write(
            Utf8JsonWriter writer,
            ApiKeyScope value,
            JsonSerializerOptions options
        )
        {
            writer.WriteStringValue(value.Value);
        }

        public override ApiKeyScope ReadAsPropertyName(
            ref Utf8JsonReader reader,
            Type typeToConvert,
            JsonSerializerOptions options
        )
        {
            var stringValue =
                reader.GetString()
                ?? throw new global::System.Exception(
                    "The JSON property name could not be read as a string."
                );
            return new ApiKeyScope(stringValue);
        }

        public override void WriteAsPropertyName(
            Utf8JsonWriter writer,
            ApiKeyScope value,
            JsonSerializerOptions options
        )
        {
            writer.WritePropertyName(value.Value);
        }
    }

    /// <summary>
    /// Constant strings for enum values
    /// </summary>
    [Serializable]
    public static class Values
    {
        public const string Publish = "publish";

        public const string ReadStats = "read_stats";

        public const string ManageKeys = "manage_keys";

        public const string ManageProject = "manage_project";
    }
}
