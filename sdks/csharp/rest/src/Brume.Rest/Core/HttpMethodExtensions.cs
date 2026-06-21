using global::System.Net.Http;

namespace Brume.Rest.Core;

internal static class HttpMethodExtensions
{
    public static readonly HttpMethod Patch = new("PATCH");
}
