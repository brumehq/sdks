<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

class WebhookDeliveryItem extends JsonSerializableType
{
    /**
     * @var int $attempts
     */
    #[JsonProperty('attempts')]
    public int $attempts;

    /**
     * @var string $createdAt RFC-3339 timestamp of delivery creation.
     */
    #[JsonProperty('created_at')]
    public string $createdAt;

    /**
     * @var string $eventType
     */
    #[JsonProperty('event_type')]
    public string $eventType;

    /**
     * @var string $id
     */
    #[JsonProperty('id')]
    public string $id;

    /**
     * @var ?string $lastAttemptAt RFC-3339 timestamp of the most recent attempt, or `null`.
     */
    #[JsonProperty('last_attempt_at')]
    public ?string $lastAttemptAt;

    /**
     * @var ?int $responseStatus HTTP status code of the most recent attempt, or `null`.
     */
    #[JsonProperty('response_status')]
    public ?int $responseStatus;

    /**
     * @var string $status `"pending" | "delivered" | "failed"`.
     */
    #[JsonProperty('status')]
    public string $status;

    /**
     * @param array{
     *   attempts: int,
     *   createdAt: string,
     *   eventType: string,
     *   id: string,
     *   status: string,
     *   lastAttemptAt?: ?string,
     *   responseStatus?: ?int,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->attempts = $values['attempts'];
        $this->createdAt = $values['createdAt'];
        $this->eventType = $values['eventType'];
        $this->id = $values['id'];
        $this->lastAttemptAt = $values['lastAttemptAt'] ?? null;
        $this->responseStatus = $values['responseStatus'] ?? null;
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
