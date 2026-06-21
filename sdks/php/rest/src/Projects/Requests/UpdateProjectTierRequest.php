<?php

namespace Brume\Rest\Projects\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

class UpdateProjectTierRequest extends JsonSerializableType
{
    /**
     * @var string $tier One of `"free" | "starter" | "pro" | "business"`.
     */
    #[JsonProperty('tier')]
    public string $tier;

    /**
     * @param array{
     *   tier: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->tier = $values['tier'];
    }
}
