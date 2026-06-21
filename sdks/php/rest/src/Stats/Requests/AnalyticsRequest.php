<?php

namespace Brume\Rest\Stats\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;

class AnalyticsRequest extends JsonSerializableType
{
    /**
     * @var ?int $windowSecs Time window in seconds. Default 3600 (1h). Clamped to [300, 21600] (5 min to 6 h).
     */
    public ?int $windowSecs;

    /**
     * @param array{
     *   windowSecs?: ?int,
     * } $values
     */
    public function __construct(
        array $values = [],
    ) {
        $this->windowSecs = $values['windowSecs'] ?? null;
    }
}
