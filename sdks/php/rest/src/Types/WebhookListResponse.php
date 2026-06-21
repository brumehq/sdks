<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `GET /v1/webhooks` success response.
 */
class WebhookListResponse extends JsonSerializableType
{
    /**
     * @var array<WebhookSummary> $webhooks
     */
    #[JsonProperty('webhooks'), ArrayType([WebhookSummary::class])]
    public array $webhooks;

    /**
     * @param array{
     *   webhooks: array<WebhookSummary>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->webhooks = $values['webhooks'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
