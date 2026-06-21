using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.ApiKeys;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class ListApiKeysTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string mockResponse = """
            {
              "api_keys": [
                {
                  "environment": "environment",
                  "id": "id",
                  "label": "label",
                  "last_used_at": "last_used_at",
                  "prefix": "prefix",
                  "scopes": [
                    "publish",
                    "publish"
                  ]
                },
                {
                  "environment": "environment",
                  "id": "id",
                  "label": "label",
                  "last_used_at": "last_used_at",
                  "prefix": "prefix",
                  "scopes": [
                    "publish",
                    "publish"
                  ]
                }
              ]
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/api-keys").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.ApiKeys.ListApiKeysAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "api_keys": [
                {
                  "environment": "environment",
                  "id": "id",
                  "label": "label",
                  "last_used_at": "last_used_at",
                  "prefix": "prefix",
                  "scopes": [
                    "publish"
                  ]
                }
              ]
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/api-keys").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.ApiKeys.ListApiKeysAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }
}
