<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `GET /v1/channels/:channel/presence` success response.
 */
class PresenceResponse extends JsonSerializableType
{
    /**
     * @var string $channel
     */
    #[JsonProperty('channel')]
    public string $channel;

    /**
     * @var int $connectionCount
     */
    #[JsonProperty('connection_count')]
    public int $connectionCount;

    /**
     * Connection roster. Empty if presence tracking is disabled or the
     * channel has no subscribers.
     *
     * @var array<ConnectionInfo> $presence
     */
    #[JsonProperty('presence'), ArrayType([ConnectionInfo::class])]
    public array $presence;

    /**
     * @param array{
     *   channel: string,
     *   connectionCount: int,
     *   presence: array<ConnectionInfo>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->channel = $values['channel'];
        $this->connectionCount = $values['connectionCount'];
        $this->presence = $values['presence'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
