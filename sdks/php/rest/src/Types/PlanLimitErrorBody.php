<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * `PLAN_LIMIT` error body. Emitted by the publish / create-project /
 * create-key / SSE / long-poll paths when the project hits a per-axis
 * cap. The `code` is always `"PLAN_LIMIT"`; the `reason` is a closed
 * enum string SDK consumers can pattern-match on.
 */
class PlanLimitErrorBody extends JsonSerializableType
{
    /**
     * @var string $code Always `"PLAN_LIMIT"`.
     */
    #[JsonProperty('code')]
    public string $code;

    /**
     * @var int $current Current count for the axis that triggered the limit.
     */
    #[JsonProperty('current')]
    public int $current;

    /**
     * The cap value, or `null` for unlimited (e.g. business tier
     * connection cap).
     *
     * @var ?int $limit
     */
    #[JsonProperty('limit')]
    public ?int $limit;

    /**
     * Human-readable message. Includes the current/limit numbers
     * and the upgrade suggestion.
     *
     * @var string $message
     */
    #[JsonProperty('message')]
    public string $message;

    /**
     * The closed-set reason. See `PlanLimitReason` in
     * `channels/types.rs` for the full list.
     *
     * @var string $reason
     */
    #[JsonProperty('reason')]
    public string $reason;

    /**
     * The next tier up the ladder that lifts this axis, or `null`
     * when the customer is already on business.
     *
     * @var ?string $upgradeTier
     */
    #[JsonProperty('upgradeTier')]
    public ?string $upgradeTier;

    /**
     * @param array{
     *   code: string,
     *   current: int,
     *   message: string,
     *   reason: string,
     *   limit?: ?int,
     *   upgradeTier?: ?string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->code = $values['code'];
        $this->current = $values['current'];
        $this->limit = $values['limit'] ?? null;
        $this->message = $values['message'];
        $this->reason = $values['reason'];
        $this->upgradeTier = $values['upgradeTier'] ?? null;
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
