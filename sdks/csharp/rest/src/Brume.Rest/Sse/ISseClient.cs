namespace Brume.Rest;

public partial interface ISseClient
{
    WithRawResponseTask SubscribeSseAsync(
        string channel,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
