using Brume.Rest.Core;
using global::System.Text.Json;
using global::System.Text.Json.Serialization;

namespace Brume.Rest;

[JsonConverter(typeof(Tier.TierSerializer))]
[Serializable]
public readonly record struct Tier : IStringEnum
{
    public static readonly Tier Free = new(Values.Free);

    public static readonly Tier Starter = new(Values.Starter);

    public static readonly Tier Pro = new(Values.Pro);

    public static readonly Tier Business = new(Values.Business);

    public Tier(string value)
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
    public static Tier FromCustom(string value)
    {
        return new Tier(value);
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

    public static bool operator ==(Tier value1, string value2) => value1.Value.Equals(value2);

    public static bool operator !=(Tier value1, string value2) => !value1.Value.Equals(value2);

    public static explicit operator string(Tier value) => value.Value;

    public static explicit operator Tier(string value) => new(value);

    internal class TierSerializer : JsonConverter<Tier>
    {
        public override Tier Read(
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
            return new Tier(stringValue);
        }

        public override void Write(Utf8JsonWriter writer, Tier value, JsonSerializerOptions options)
        {
            writer.WriteStringValue(value.Value);
        }

        public override Tier ReadAsPropertyName(
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
            return new Tier(stringValue);
        }

        public override void WriteAsPropertyName(
            Utf8JsonWriter writer,
            Tier value,
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
        public const string Free = "free";

        public const string Starter = "starter";

        public const string Pro = "pro";

        public const string Business = "business";
    }
}
