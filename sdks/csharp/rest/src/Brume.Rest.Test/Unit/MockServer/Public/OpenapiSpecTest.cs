using Brume.Rest.Test.Unit.MockServer;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Public;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class OpenapiSpecTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public void MockServerTest_1()
    {
        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/openapi.json").UsingGet())
            .RespondWith(WireMock.ResponseBuilders.Response.Create().WithStatusCode(200));

        Assert.DoesNotThrowAsync(async () => await Client.Public.OpenapiSpecAsync());
    }

    [NUnit.Framework.Test]
    public void MockServerTest_2()
    {
        Server
            .Given(WireMock.RequestBuilders.Request.Create().WithPath("/openapi.json").UsingGet())
            .RespondWith(WireMock.ResponseBuilders.Response.Create().WithStatusCode(200));

        Assert.DoesNotThrowAsync(async () => await Client.Public.OpenapiSpecAsync());
    }
}
