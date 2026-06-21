<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

class ConnectionInfo extends JsonSerializableType
{
    /**
     * @var mixed $state
     */
    #[JsonProperty('state')]
    public mixed $state;

    /**
     * @var string $updatedAt RFC-3339 timestamp of the last presence update.
     */
    #[JsonProperty('updated_at')]
    public string $updatedAt;

    /**
     * @var string $userId
     */
    #[JsonProperty('user_id')]
    public string $userId;

    /**
     * @param array{
     *   state: mixed,
     *   updatedAt: string,
     *   userId: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->state = $values['state'];
        $this->updatedAt = $values['updatedAt'];
        $this->userId = $values['userId'];
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
