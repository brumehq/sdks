<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `GET /readyz` failure body (HTTP 503).
 */
class NotReadyResponse extends JsonSerializableType
{
    /**
     * @var string $reason One of: `"db pool closed"`, `"db query failed"`, `"db query timeout"`.
     */
    #[JsonProperty('reason')]
    public string $reason;

    /**
     * @var string $status
     */
    #[JsonProperty('status')]
    public string $status;

    /**
     * @param array{
     *   reason: string,
     *   status: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->reason = $values['reason'];
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
