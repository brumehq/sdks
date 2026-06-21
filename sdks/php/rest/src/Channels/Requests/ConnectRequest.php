<?php

namespace Brume\Rest\Channels\Requests;

use Brume\Rest\Core\Json\JsonSerializableType;

class ConnectRequest extends JsonSerializableType
{
    /**
     * @var ?string $token Legacy JWT query parameter. Prefer the `Sec-WebSocket-Protocol: brume.token.<jwt>` subprotocol, which keeps the token out of access logs, browser history, and the `Referer` header.
     */
    public ?string $token;

    /**
     * @param array{
     *   token?: ?string,
     * } $values
     */
    public function __construct(
        array $values = [],
    ) {
        $this->token = $values['token'] ?? null;
    }
}
