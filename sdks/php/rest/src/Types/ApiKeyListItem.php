<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

class ApiKeyListItem extends JsonSerializableType
{
    /**
     * @var string $environment
     */
    #[JsonProperty('environment')]
    public string $environment;

    /**
     * @var string $id
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var string $label
     */
    #[JsonProperty('label')]
    public string $label;

    /**
     * @var ?string $lastUsedAt RFC-3339 timestamp of last use, or `null` if never used.
     */
    #[JsonProperty('last_used_at')]
    public ?string $lastUsedAt;

    /**
     * @var string $prefix
     */
    #[JsonProperty('prefix')]
    public string $prefix;

    /**
     * @var array<value-of<ApiKeyScope>> $scopes Granted scopes (E6). Serializes as snake_case strings.
     */
    #[JsonProperty('scopes'), ArrayType(['string'])]
    public array $scopes;

    /**
     * @param array{
     *   environment: string,
     *   id: string,
     *   label: string,
     *   prefix: string,
     *   scopes: array<value-of<ApiKeyScope>>,
     *   lastUsedAt?: ?string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->environment = $values['environment'];
        $this->id = $values['id'];
        $this->label = $values['label'];
        $this->lastUsedAt = $values['lastUsedAt'] ?? null;
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
