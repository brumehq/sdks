<?php

namespace Brume\Rest\Channels\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Core\Types\ArrayType;

class PublishRequest extends JsonSerializableType
{
    /**
     * Event name. 1-256 chars. Allowed: alphanumeric, `:`, `-`, `_`, `.`.
     * Must NOT start with `brume:` (reserved for system events).
     *
     * @var string $event
     */
    #[JsonProperty('event')]
    public string $event;

    /**
     * @var array<string, mixed> $payload Free-form JSON payload delivered to subscribers.
     */
    #[JsonProperty('payload'), ArrayType(['string' => 'mixed'])]
    public array $payload;

    /**
     * @var ?string $ref Optional client-generated idempotency key. Echoed in `brume:ack`.
     */
    #[JsonProperty('ref')]
    public ?string $ref;

    /**
     * @param array{
     *   event: string,
     *   payload: array<string, mixed>,
     *   ref?: ?string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->event = $values['event'];
        $this->payload = $values['payload'];
        $this->ref = $values['ref'] ?? null;
    }
}
