using Brume.Rest;
using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Stats;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class AnalyticsTest : BaseMockServerTest
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
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/analytics").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Stats.AnalyticsAsync(new AnalyticsRequest());
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "generated_at": "2026-06-20T00:00:00Z",
              "interval_seconds": 30,
              "snapshots": {
                "key": "value"
              },
              "window_seconds": 3600
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/v1/analytics").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Stats.AnalyticsAsync(new AnalyticsRequest());
        JsonAssert.AreEqual(response, mockResponse);
    }
}
