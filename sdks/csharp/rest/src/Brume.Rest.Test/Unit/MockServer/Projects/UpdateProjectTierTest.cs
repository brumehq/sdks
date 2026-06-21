using Brume.Rest;
using Brume.Rest.Test.Unit.MockServer;
using Brume.Rest.Test.Utils;
using NUnit.Framework;

namespace Brume.Rest.Test.Unit.MockServer.Projects;

[TestFixture]
[Parallelizable(ParallelScope.Self)]
public class UpdateProjectTierTest : BaseMockServerTest
{
    [NUnit.Framework.Test]
    public async Task MockServerTest_1()
    {
        const string requestJson = """
            {
              "tier": "tier"
            }
            """;

        const string mockResponse = """
            {
              "id": "id",
              "max_connections": 1000000,
              "tier": "tier"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/projects/id/tier")
                    .WithHeader("Content-Type", "application/json")
                    .UsingPatch()
                    .WithBodyAsJson(requestJson)
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Projects.UpdateProjectTierAsync(
            "id",
            new UpdateProjectTierRequest { Tier = "tier" }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }

    [NUnit.Framework.Test]
    public async Task MockServerTest_2()
    {
        const string requestJson = """
            {
              "tier": "tier"
            }
            """;

        const string mockResponse = """
            {
              "id": "id",
              "max_connections": 1000000,
              "tier": "tier"
            }
            """;

        Server
            .Given(
                WireMock
                    .RequestBuilders.Request.Create()
                    .WithPath("/v1/projects/id/tier")
                    .WithHeader("Content-Type", "application/json")
                    .UsingPatch()
                    .WithBodyAsJson(requestJson)
            )
            .RespondWith(
                WireMock
                    .ResponseBuilders.Response.Create()
                    .WithStatusCode(200)
                    .WithBody(mockResponse)
            );

        var response = await Client.Projects.UpdateProjectTierAsync(
            "id",
            new UpdateProjectTierRequest { Tier = "tier" }
        );
        JsonAssert.AreEqual(response, mockResponse);
    }
}
