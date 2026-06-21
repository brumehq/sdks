<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `PATCH /v1/projects/:id/tier` success response.
 */
class UpdateProjectTierResponse extends JsonSerializableType
{
    /**
     * @var string $id Echo of the path param (hex-encoded project id).
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var int $maxConnections
     */
    #[JsonProperty('max_connections')]
    public int $maxConnections;

    /**
     * @var string $tier
     */
    #[JsonProperty('tier')]
    public string $tier;

    /**
     * @param array{
     *   id: string,
     *   maxConnections: int,
     *   tier: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->id = $values['id'];
        $this->maxConnections = $values['maxConnections'];
        $this->tier = $values['tier'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
