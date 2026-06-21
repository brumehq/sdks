<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `GET /v1/webhooks/:id/deliveries` success response.
 */
class WebhookDeliveryListResponse extends JsonSerializableType
{
    /**
     * @var array<WebhookDeliveryItem> $deliveries
     */
    #[JsonProperty('deliveries'), ArrayType([WebhookDeliveryItem::class])]
    public array $deliveries;

    /**
     * @param array{
     *   deliveries: array<WebhookDeliveryItem>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->deliveries = $values['deliveries'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
