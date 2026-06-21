using Brume.Rest;
using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.ApiKeys;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class CreateApiKeyTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string requestJson = """
            {
              "environment": "environment",
              "label": "label"
            }
            """;

        const string mockResponse = """
            {
              "environment": "environment",
              "id": "id",
              "key": "key",
              "label": "label",
              "prefix": "prefix",
              "scopes": [
                "publish",
                "publish"
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/api-keys")
                    .WithHeader("Content-Type", "application/json")
                    .UsingPost()
                    .WithBodyAsJson(requestJson)
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.ApiKeys.CreateApiKeyAsync(
            new CreateApiKeyRequest
            {
                Environment = "environment",
                Label = "label",
                Scopes = null,
            }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string requestJson = """
            {
              "environment": "environment",
              "label": "label"
            }
            """;

        const string mockResponse = """
            {
              "environment": "environment",
              "id": "id",
              "key": "key",
              "label": "label",
              "prefix": "prefix",
              "scopes": [
                "publish"
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/api-keys")
                    .WithHeader("Content-Type", "application/json")
                    .UsingPost()
                    .WithBodyAsJson(requestJson)
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.ApiKeys.CreateApiKeyAsync(
            new CreateApiKeyRequest { Environment = "environment", Label = "label" }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }
}
