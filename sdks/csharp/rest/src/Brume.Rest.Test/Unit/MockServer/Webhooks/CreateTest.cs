using Brume.Rest;
using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Webhooks;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class CreateTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string requestJson = """
            {
              "events": [
                "events",
                "events"
              ],
              "url": "url"
            }
            """;

        const string mockResponse = """
            {
              "events": [
                "events",
                "events"
              ],
              "id": "id",
              "secret": "secret",
              "url": "url"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/webhooks")
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

        var response = await Client.Webhooks.CreateAsync(
            new CreateWebhookRequest
            {
                Events = new List<string>() { "events", "events" },
                Url = "url",
            }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string requestJson = """
            {
              "events": [
                "events"
              ],
              "url": "url"
            }
            """;

        const string mockResponse = """
            {
              "events": [
                "events"
              ],
              "id": "id",
              "secret": "secret",
              "url": "url"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/webhooks")
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

        var response = await Client.Webhooks.CreateAsync(
            new CreateWebhookRequest
            {
                Events = new List<string>() { "events" },
                Url = "url",
            }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }
}
