<?php

namespace Brume\Rest\ApiKeys\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;
use Brume\Rest\Core\Json\JsonProperty;
use Brume\Rest\Types\ApiKeyScope;
use Brume\Rest\Core\Types\ArrayType;

class CreateApiKeyRequest extends JsonSerializableType
{
    /**
     * `"live"` or `"test"`. Determines the key prefix
     * (`pk_live_` vs `pk_test_`) and the default scope set.
     *
     * @var string $environment
     */
    #[JsonProperty('environment')]
    public string $environment;

    /**
     * @var string $label Human-readable label. Shown in the dashboard.
     */
    #[JsonProperty('label')]
    public string $label;

    /**
     * Optional explicit scopes. Omit to receive the default scope set
     * (`publish`, `read_stats`, `manage_keys`).
     *
     * @var ?array<value-of<ApiKeyScope>> $scopes
     */
    #[JsonProperty('scopes'), ArrayType(['string'])]
    public ?array $scopes;

    /**
     * @param array{
     *   environment: string,
     *   label: string,
     *   scopes?: ?array<value-of<ApiKeyScope>>,
     * } $values
     */
    public function __construct(
        array $values,
    ) {
        $this->environment = $values['environment'];
        $this->label = $values['label'];
        $this->scopes = $values['scopes'] ?? null;
    }
}
