<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `GET /v1/project` success response.
 */
class ProjectResponse extends JsonSerializableType
{
    /**
     * @var string $createdAt RFC-3339 timestamp of project creation.
     */
    #[JsonProperty('created_at')]
    public string $createdAt;

    /**
     * @var string $id Hex-encoded 16-byte project id.
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var int $maxConnections
     */
    #[JsonProperty('max_connections')]
    public int $maxConnections;

    /**
     * @var string $name
     */
    #[JsonProperty('name')]
    public string $name;

    /**
     * @var string $tier
     */
    #[JsonProperty('tier')]
    public string $tier;

    /**
     * @param array{
     *   createdAt: string,
     *   id: string,
     *   maxConnections: int,
     *   name: string,
     *   tier: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->createdAt = $values['createdAt'];
        $this->id = $values['id'];
        $this->maxConnections = $values['maxConnections'];
        $this->name = $values['name'];
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
