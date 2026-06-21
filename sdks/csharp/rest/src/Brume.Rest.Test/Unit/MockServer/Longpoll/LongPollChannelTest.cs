using Brume.Rest.Test.Unit.MockServer;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Longpoll;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class LongPollChannelTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public void MockServerTest_1()
    {
        Server
            .Given(
                WireMock.RequestBuilders.Request.Create().WithPath("/v1/poll/channel").UsingPost()
            )
            .RespondWith(WireMock.ResponseBuilders.Response.Create().WithStatusCode(200));

        Assert.DoesNotThrowAsync(async () => await Client.Longpoll.LongPollChannelAsync("channel"));
    }

    [NUnit.Framework.Test]
    public void MockServerTest_2()
    {
        Server
            .Given(
                WireMock.RequestBuilders.Request.Create().WithPath("/v1/poll/channel").UsingPost()
            )
            .RespondWith(WireMock.ResponseBuilders.Response.Create().WithStatusCode(200));

        Assert.DoesNotThrowAsync(async () => await Client.Longpoll.LongPollChannelAsync("channel"));
    }
}
