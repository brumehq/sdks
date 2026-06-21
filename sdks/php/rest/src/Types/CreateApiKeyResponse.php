<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `POST /v1/api-keys` success response. The `key` field is the raw
 * key returned exactly once; clients must store it before navigating
 * away.
 */
class CreateApiKeyResponse extends JsonSerializableType
{
    /**
     * @var string $environment
     */
    #[JsonProperty('environment')]
    public string $environment;

    /**
     * @var string $id Hex-encoded key id.
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var string $key The raw API key. Only returned by the create endpoint.
     */
    #[JsonProperty('key')]
    public string $key;

    /**
     * @var string $label
     */
    #[JsonProperty('label')]
    public string $label;

    /**
     * @var string $prefix 28-char prefix used for O(1) lookup. Safe to display.
     */
    #[JsonProperty('prefix')]
    public string $prefix;

    /**
     * Granted scopes (E6). Serializes as the snake_case string form
     * (`"publish"`, `"read_stats"`, `"manage_keys"`, `"manage_project"`).
     *
     * @var array<value-of<ApiKeyScope>> $scopes
     */
    #[JsonProperty('scopes'), ArrayType(['string'])]
    public array $scopes;

    /**
     * @param array{
     *   environment: string,
     *   id: string,
     *   key: string,
     *   label: string,
     *   prefix: string,
     *   scopes: array<value-of<ApiKeyScope>>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->environment = $values['environment'];
        $this->id = $values['id'];
        $this->key = $values['key'];
        $this->label = $values['label'];
        $this->prefix = $values['prefix'];
        $this->scopes = $values['scopes'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
