<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `DELETE /v1/api-keys/:id` success response.
 */
class RevokeApiKeyResponse extends JsonSerializableType
{
    /**
     * @var string $status Always `"revoked"`.
     */
    #[JsonProperty('status')]
    public string $status;

    /**
     * @param array{
     *   status: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
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
