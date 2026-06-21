using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Stats;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class GetStatsTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string mockResponse = """
            {
              "string": {
                "key": "value"
              }
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/stats").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Stats.GetStatsAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "dropped_messages": 0,
              "global": {
                "channels": 5,
                "connections": 12
              },
              "latency": {
                "p50": 42,
                "p95": 80,
                "p99": 120
              },
              "postgres_lag": {
                "enabled": false
              },
              "project": {
                "channels": 2,
                "connections": 7,
                "id": "abcdef01",
                "tier": "pro"
              },
              "top_channels": {
                "key": "value"
              }
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/stats").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Stats.GetStatsAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }
}
