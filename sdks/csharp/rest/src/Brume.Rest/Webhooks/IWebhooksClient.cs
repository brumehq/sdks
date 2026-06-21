namespace Brume.Rest;

public partial interface IWebhooksClient
{
    WithRawResponseTask<WebhookListResponse> ListAsync(
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    WithRawResponseTask<WebhookCreatedResponse> CreateAsync(
        CreateWebhookRequest request,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    WithRawResponseTask<WebhookDeleteResponse> DeleteAsync(
        string id,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    WithRawResponseTask<WebhookDeliveryListResponse> ListDeliveriesAsync(
        string id,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );

    WithRawResponseTask<WebhookTestResponse> TestAsync(
        string id,
        RequestOptions? options = null,
        CancellationToken cancellationToken = default
    );
}
