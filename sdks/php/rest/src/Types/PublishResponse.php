<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `POST /v1/channels/:channel/publish` success response.
 */
class PublishResponse extends JsonSerializableType
{
    /**
     * @var string $channel
     */
    #[JsonProperty('channel')]
    public string $channel;

    /**
     * @var string $event
     */
    #[JsonProperty('event')]
    public string $event;

    /**
     * @var int $recipients Number of subscribers the message was fanned out to.
     */
    #[JsonProperty('recipients')]
    public int $recipients;

    /**
     * @var string $status Always `"published"`. Reserved for future state changes.
     */
    #[JsonProperty('status')]
    public string $status;

    /**
     * @param array{
     *   channel: string,
     *   event: string,
     *   recipients: int,
     *   status: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->channel = $values['channel'];
        $this->event = $values['event'];
        $this->recipients = $values['recipients'];
        $this->status = $values['status'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
