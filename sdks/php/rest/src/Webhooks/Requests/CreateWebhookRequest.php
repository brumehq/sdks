<?php

namespace Brume\Rest\Webhooks\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

class CreateWebhookRequest extends JsonSerializableType
{
    /**
     * @var array<string> $events Event names to subscribe to (e.g. `["channel.message.published"]`).
     */
    #[JsonProperty('events'), ArrayType(['string'])]
    public array $events;

    /**
     * @var string $url Destination URL. Validated by `webhook_validation::validate_webhook_url`.
     */
    #[JsonProperty('url')]
    public string $url;

    /**
     * @param array{
     *   events: array<string>,
     *   url: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->events = $values['events'];
        $this->url = $values['url'];
    }
}
