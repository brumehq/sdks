<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

/**
 * `GET /v1/api-keys` success response.
 */
class ApiKeyListResponse extends JsonSerializableType
{
    /**
     * @var array<ApiKeyListItem> $apiKeys
     */
    #[JsonProperty('api_keys'), ArrayType([ApiKeyListItem::class])]
    public array $apiKeys;

    /**
     * @param array{
     *   apiKeys: array<ApiKeyListItem>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->apiKeys = $values['apiKeys'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
