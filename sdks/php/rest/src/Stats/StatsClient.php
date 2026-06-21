<?php

namespace Brume\Rest\Stats;

use Psr\Http\Client\ClientInterface;
use Brume\Rest\Core\Client\RawClient;
use Brume\Rest\Stats\Requests\AnalyticsRequest;
use Brume\Rest\Exceptions\BrumeException;
use Brume\Rest\Exceptions\BrumeApiException;
use Brume\Rest\Core\Json\JsonApiRequest;
use Brume\Rest\Core\Client\HttpMethod;
use Brume\Rest\Core\Json\JsonDecoder;
use JsonException;
use Psr\Http\Client\ClientExceptionInterface;

class StatsClient
{
    /**
     * @var array{
     *   baseUrl?: string,
     *   client?: ClientInterface,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     * } $options @phpstan-ignore-next-line Property is used in endpoint methods via HttpEndpointGenerator
     */
    private array $options;

    /**
     * @var RawClient $client
     */
    private RawClient $client;

    /**
     * @param RawClient $client
     * @param ?array{
     *   baseUrl?: string,
     *   client?: ClientInterface,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     * } $options
     */
    public function __construct(
        RawClient $client,
        ?array $options = null,
    ) {
        $this->client = $client;
        $this->options = $options ?? [];
    }

    /**
     * Returns the project's analytics history as a list of snapshots
     * (oldest first). Snapshots are sampled every 30s in-process. The
     * response includes the last `window / interval` entries. Empty
     * state is an empty `snapshots` array — never faked data.
     *
     * Response body is documented as `additionalProperties: true` for
     * the same reason as `/v1/stats`: the shape is pinned by tests.
     *
     * @param AnalyticsRequest $request
     * @param ?array{
     *   baseUrl?: string,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     *   queryParameters?: array<string, mixed>,
     *   bodyProperties?: array<string, mixed>,
     * } $options
     * @return ?array<string, mixed>
     * @throws BrumeException
     * @throws BrumeApiException
     */
    public function analytics(AnalyticsRequest $request = new AnalyticsRequest(), ?array $options = null): ?array
    {
        $options = array_merge($this->options, $options ?? []);
        $query = [];
        if ($request->windowSecs != null) {
            $query['window_secs'] = $request->windowSecs;
        }
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/analytics",
                    method: HttpMethod::GET,
                    query: $query,
                ),
                $options,
            );
            $statusCode = $response->getStatusCode();
            if ($statusCode >= 200 && $statusCode < 400) {
                $json = $response->getBody()->getContents();
                if (empty($json)) {
                    return null;
                }
                return JsonDecoder::decodeArray($json, ['string' => 'mixed']); // @phpstan-ignore-line
            }
        } catch (JsonException $e) {
            throw new BrumeException(message: "Failed to deserialize response: {$e->getMessage()}", previous: $e);
        } catch (ClientExceptionInterface $e) {
            throw new BrumeException(message: $e->getMessage(), previous: $e);
        }
        throw new BrumeApiException(
            message: 'API request failed',
            statusCode: $statusCode,
            body: $response->getBody()->getContents(),
        );
    }

    /**
     * Returns project-level and global connection/channel statistics.
     *
     * Backwards compatibility: existing fields are preserved exactly. New
     * fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
     * slow_consumer_disconnections, dead_connections_cleaned,
     * auth_failures_last_minute, plan_limit_rejections, top_channels) are
     * additive — older dashboard clients keep working.
     *
     * Response body is documented as `additionalProperties: true` because
     * the exact JSON shape is pinned by ~10 unit tests in this file. A
     * future PR can type the envelope; for now SDK consumers will see
     * `Record<string, any>`.
     *
     * @param ?array{
     *   baseUrl?: string,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     *   queryParameters?: array<string, mixed>,
     *   bodyProperties?: array<string, mixed>,
     * } $options
     * @return ?array<string, mixed>
     * @throws BrumeException
     * @throws BrumeApiException
     */
    public function getStats(?array $options = null): ?array
    {
        $options = array_merge($this->options, $options ?? []);
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/stats",
                    method: HttpMethod::GET,
                ),
                $options,
            );
            $statusCode = $response->getStatusCode();
            if ($statusCode >= 200 && $statusCode < 400) {
                $json = $response->getBody()->getContents();
                if (empty($json)) {
                    return null;
                }
                return JsonDecoder::decodeArray($json, ['string' => 'mixed']); // @phpstan-ignore-line
            }
        } catch (JsonException $e) {
            throw new BrumeException(message: "Failed to deserialize response: {$e->getMessage()}", previous: $e);
        } catch (ClientExceptionInterface $e) {
            throw new BrumeException(message: $e->getMessage(), previous: $e);
        }
        throw new BrumeApiException(
            message: 'API request failed',
            statusCode: $statusCode,
            body: $response->getBody()->getContents(),
        );
    }
}
