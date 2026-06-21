<?php

namespace Brume\Rest\Projects\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

class CreateProjectRequest extends JsonSerializableType
{
    /**
     * @var string $name 1-128 chars.
     */
    #[JsonProperty('name')]
    public string $name;

    /**
     * @param array{
     *   name: string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->name = $values['name'];
    }
}
