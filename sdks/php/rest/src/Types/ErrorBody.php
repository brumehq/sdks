<?php

namespace Brume\Rest\Types;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;

/**
 * Standard error response body returned by all REST endpoints on 4xx/5xx.
 *
 * The legacy handlers emit `{"error": "..."}` (string-only). The newer
 * handlers emit `{"error": "CODE", "message": "human-readable"}`. Both
 * shapes parse into this struct; the `message` field is optional for
 * back-compat.
 */
class ErrorBody extends JsonSerializableType
{
    /**
     * Short error code. Either a stable machine code (`AUTH_INVALID`,
     * `RATE_LIMITED`, `EMAIL_NOT_VERIFIED`, etc.) or a free-form string
     * for legacy handlers. SDK consumers should pattern-match the
     * well-known codes and treat unknown values as opaque failures.
     *
     * @var string $error
     */
    #[JsonProperty('error')]
    public string $error;

    /**
     * @var ?string $message Human-readable description. Absent on legacy string-only errors.
     */
    #[JsonProperty('message')]
    public ?string $message;

    /**
     * @param array{
     *   error: string,
     *   message?: ?string,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->error = $values['error'];
        $this->message = $values['message'] ?? null;
    }

    /**
     * @return string
     */
    public function __toString(): string
    {
        return $this->toJson();
    }
}
