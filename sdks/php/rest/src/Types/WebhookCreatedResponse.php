<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `POST /v1/webhooks` success response. Includes the `secret` field
 * which is only returned at creation time.
 */
class WebhookCreatedResponse extends JsonSerializableType
{
    /**
     * @var array<string> $events
     */
    #[JsonProperty('events'), ArrayType(['string'])]
    public array $events;

    /**
     * @var string $id
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var string $secret HMAC-SHA256 secret used to sign deliveries. Only returned once.
     */
    #[JsonProperty('secret')]
    public string $secret;

    /**
     * @var string $url
     */
    #[JsonProperty('url')]
    public string $url;

    /**
     * @param array{
     *   events: array<string>,
     *   id: string,
     *   secret: string,
     *   url: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->events = $values['events'];
        $this->id = $values['id'];
        $this->secret = $values['secret'];
        $this->url = $values['url'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
