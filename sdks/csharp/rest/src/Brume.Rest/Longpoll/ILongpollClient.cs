namespace Brume.Rest;

public partial interface ILongpollClient
{
    WithRawResponseTask LongPollChannelAsync(
        string channel,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
