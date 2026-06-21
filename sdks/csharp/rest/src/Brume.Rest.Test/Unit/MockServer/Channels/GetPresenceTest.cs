using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Channels;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class GetPresenceTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string mockResponse = """
            {
              "channel": "channel",
              "connection_count": 1,
              "presence": [
                {
                  "state": {
                    "key": "value"
                  },
                  "updated_at": "updated_at",
                  "user_id": "user_id"
                },
                {
                  "state": {
                    "key": "value"
                  },
                  "updated_at": "updated_at",
                  "user_id": "user_id"
                }
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/channels/channel/presence")
                    .UsingGet()
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Channels.GetPresenceAsync("channel");
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "channel": "channel",
              "connection_count": 1,
              "presence": [
                {
                  "state": {
                    "key": "value"
                  },
                  "updated_at": "updated_at",
                  "user_id": "user_id"
                }
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/channels/channel/presence")
                    .UsingGet()
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Channels.GetPresenceAsync("channel");
        JsonAssert.AreEqual(response, mockResponse);
    }
}
