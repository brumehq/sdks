using Brume.Rest;
using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Channels;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class PublishTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string requestJson = """
            {
              "event": "event",
              "payload": {
                "payload": {
                  "key": "value"
                }
              }
            }
            """;

        const string mockResponse = """
            {
              "channel": "channel",
              "event": "event",
              "recipients": 1,
              "status": "status"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/channels/channel/publish")
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

        var response = await Client.Channels.PublishAsync(
            "channel",
            new PublishRequest
            {
                Event = "event",
                Payload = new Dictionary<string, object?>()
                {
                    {
                        "payload",
                        new Dictionary<object, object?>() { { "key", "value" } }
                    },
                },
                Ref = null,
            }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string requestJson = """
            {
              "event": "event",
              "payload": {
                "key": "value"
              }
            }
            """;

        const string mockResponse = """
            {
              "channel": "channel",
              "event": "event",
              "recipients": 1,
              "status": "status"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/channels/channel/publish")
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

        var response = await Client.Channels.PublishAsync(
            "channel",
            new PublishRequest
            {
                Event = "event",
                Payload = new Dictionary<string, object?>() { { "key", "value" } },
            }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }
}
