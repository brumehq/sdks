using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Public;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class ReadyzTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string mockResponse = """
            {
              "status": "status"
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/readyz").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Public.ReadyzAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string mockResponse = """
            {
              "status": "status"
            }
            """;

        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/readyz").UsingGet())
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Public.ReadyzAsync();
        JsonAssert.AreEqual(response, mockResponse);
    }
}
