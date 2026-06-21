<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `POST /v1/projects` success response. The `api_key` field is the only
 * time the raw key is returned; clients must store it immediately.
 */
class CreateProjectResponse extends JsonSerializableType
{
    /**
     * The raw API key. `null` after the first call (the server does
     * not retain plaintext keys).
     *
     * @var string $apiKey
     */
    #[JsonProperty('api_key')]
    public string $apiKey;

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
     *   apiKey: string,
     *   id: string,
     *   maxConnections: int,
     *   name: string,
     *   tier: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->apiKey = $values['apiKey'];
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
