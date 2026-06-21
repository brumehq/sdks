using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Webhooks;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class ListDeliveriesTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string mockResponse = """
            {
              "deliveries": [
                {
                  "attempts": 1,
                  "created_at": "created_at",
                  "event_type": "event_type",
                  "id": "id",
                  "last_attempt_at": "last_attempt_at",
                  "response_status": 1,
                  "status": "status"
                },
                {
                  "attempts": 1,
                  "created_at": "created_at",
                  "event_type": "event_type",
                  "id": "id",
                  "last_attempt_at": "last_attempt_at",
                  "response_status": 1,
                  "status": "status"
                }
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/webhooks/id/deliveries")
                    .UsingGet()
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Webhooks.ListDeliveriesAsync("id");
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "deliveries": [
                {
                  "attempts": 1,
                  "created_at": "created_at",
                  "event_type": "event_type",
                  "id": "id",
                  "last_attempt_at": "last_attempt_at",
                  "response_status": 1,
                  "status": "status"
                }
              ]
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/webhooks/id/deliveries")
                    .UsingGet()
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Webhooks.ListDeliveriesAsync("id");
        JsonAssert.AreEqual(response, mockResponse);
    }
}
