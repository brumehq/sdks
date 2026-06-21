<?php

namespace Brume\Rest;

use Brume\Rest\Public_\PublicClient;
use Brume\Rest\Stats\StatsClient;
use Brume\Rest\ApiKeys\ApiKeysClient;
use Brume\Rest\Channels\ChannelsClient;
use Brume\Rest\Longpoll\LongpollClient;
use Brume\Rest\Postgres\PostgresClient;
use Brume\Rest\Projects\ProjectsClient;
use Brume\Rest\Sse\SseClient;
use Brume\Rest\Webhooks\WebhooksClient;
use Psr\Http\Client\ClientInterface;
use Brume\Rest\Core\Client\RawClient;
use Brume\Rest\Exceptions\BrumeException;
use Brume\Rest\Exceptions\BrumeApiException;
use Brume\Rest\Core\Json\JsonApiRequest;
use Brume\Rest\Core\Client\HttpMethod;
use Brume\Rest\Core\Json\JsonDecoder;
use JsonException;
use Psr\Http\Client\ClientExceptionInterface;
use Exception;

class BrumeClient
{
    /**
     * @var PublicClient $public_
     */
    public PublicClient $public_;

    /**
     * @var StatsClient $stats
     */
    public StatsClient $stats;

    /**
     * @var ApiKeysClient $apiKeys
     */
    public ApiKeysClient $apiKeys;

    /**
     * @var ChannelsClient $channels
     */
    public ChannelsClient $channels;

    /**
     * @var LongpollClient $longpoll
     */
    public LongpollClient $longpoll;

    /**
     * @var PostgresClient $postgres
     */
    public PostgresClient $postgres;

    /**
     * @var ProjectsClient $projects
     */
    public ProjectsClient $projects;

    /**
     * @var SseClient $sse
     */
    public SseClient $sse;

    /**
     * @var WebhooksClient $webhooks
     */
    public WebhooksClient $webhooks;

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
     * @param ?string $apiKey The apiKey to use for authentication.
     * @param ?array{
     *   baseUrl?: string,
     *   client?: ClientInterface,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     * } $options
     */
    public function __construct(
        ?string $apiKey = null,
        ?array $options = null,
    ) {
        $apiKey ??= $this->getFromEnvOrThrow('BRUME_API_KEY', 'Please pass in apiKey or set the environment variable BRUME_API_KEY.');
        $defaultHeaders = [
            'Authorization' => "Bearer $apiKey",
            'X-Fern-Language' => 'PHP',
            'X-Fern-SDK-Name' => 'Brume\Rest',
        ];

        $this->options = $options ?? [];

        $this->options['headers'] = array_merge(
            $defaultHeaders,
            $this->options['headers'] ?? [],
        );

        $this->client = new RawClient(
            options: $this->options,
        );

        $this->public_ = new PublicClient($this->client, $this->options);
        $this->stats = new StatsClient($this->client, $this->options);
        $this->apiKeys = new ApiKeysClient($this->client, $this->options);
        $this->channels = new ChannelsClient($this->client, $this->options);
        $this->longpoll = new LongpollClient($this->client, $this->options);
        $this->postgres = new PostgresClient($this->client, $this->options);
        $this->projects = new ProjectsClient($this->client, $this->options);
        $this->sse = new SseClient($this->client, $this->options);
        $this->webhooks = new WebhooksClient($this->client, $this->options);
    }

    /**
     * Returns the full operational picture for a project: counters,
     * latency percentiles, Postgres lag, top channels, and a plan-limit
     * snapshot. Project API key auth (any scope). No secrets, no
     * high-cardinality data, no admin gating.
     *
     * Response body is documented as `additionalProperties: true` for
     * the same reason as `/v1/stats` and `/v1/analytics`.
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
    public function diagnostics(?array $options = null): ?array
    {
        $options = array_merge($this->options, $options ?? []);
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/diagnostics",
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

    /**
     * @param string $env
     * @param string $message
     * @return string
     */
    private function getFromEnvOrThrow(string $env, string $message): string
    {
        $value = getenv($env);
        return $value ? (string) $value : throw new Exception($message);
    }
}
