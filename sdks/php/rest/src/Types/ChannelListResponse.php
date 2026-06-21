<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `GET /v1/channels` success response.
 */
class ChannelListResponse extends JsonSerializableType
{
    /**
     * @var array<ChannelSummary> $channels
     */
    #[JsonProperty('channels'), ArrayType([ChannelSummary::class])]
    public array $channels;

    /**
     * @param array{
     *   channels: array<ChannelSummary>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->channels = $values['channels'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
