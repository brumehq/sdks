<?php

namespace Brume\Rest\Projects;

use Psr\Http\Client\ClientInterface;
use Brume\Rest\Core\Client\RawClient;
use Brume\Rest\Types\ProjectResponse;
use Brume\Rest\Exceptions\BrumeException;
use Brume\Rest\Exceptions\BrumeApiException;
use Brume\Rest\Core\Json\JsonApiRequest;
use Brume\Rest\Core\Client\HttpMethod;
use JsonException;
use Psr\Http\Client\ClientExceptionInterface;
use Brume\Rest\Projects\Requests\CreateProjectRequest;
use Brume\Rest\Types\CreateProjectResponse;
use Brume\Rest\Projects\Requests\UpdateProjectTierRequest;
use Brume\Rest\Types\UpdateProjectTierResponse;

class ProjectsClient
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
     * Returns full project info for the dashboard.
     *
     * @param ?array{
     *   baseUrl?: string,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     *   queryParameters?: array<string, mixed>,
     *   bodyProperties?: array<string, mixed>,
     * } $options
     * @return ?ProjectResponse
     * @throws BrumeException
     * @throws BrumeApiException
     */
    public function getProject(?array $options = null): ?ProjectResponse
    {
        $options = array_merge($this->options, $options ?? []);
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/project",
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
                return ProjectResponse::fromJson($json);
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
     * Creates a new project with an initial API key. Gated on email verification.
     *
     * @param CreateProjectRequest $request
     * @param ?array{
     *   baseUrl?: string,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     *   queryParameters?: array<string, mixed>,
     *   bodyProperties?: array<string, mixed>,
     * } $options
     * @return ?CreateProjectResponse
     * @throws BrumeException
     * @throws BrumeApiException
     */
    public function createProject(CreateProjectRequest $request, ?array $options = null): ?CreateProjectResponse
    {
        $options = array_merge($this->options, $options ?? []);
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/projects",
                    method: HttpMethod::POST,
                    body: $request,
                ),
                $options,
            );
            $statusCode = $response->getStatusCode();
            if ($statusCode >= 200 && $statusCode < 400) {
                $json = $response->getBody()->getContents();
                if (empty($json)) {
                    return null;
                }
                return CreateProjectResponse::fromJson($json);
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
     * Internal sync endpoint used by the dashboard after Polar.sh webhook
     * processing. Gated by `BRUME_INTERNAL_TOKEN`.
     *
     * @param string $id Hex-encoded project id (16 bytes → 32 hex chars).
     * @param UpdateProjectTierRequest $request
     * @param ?array{
     *   baseUrl?: string,
     *   maxRetries?: int,
     *   timeout?: float,
     *   headers?: array<string, string>,
     *   queryParameters?: array<string, mixed>,
     *   bodyProperties?: array<string, mixed>,
     * } $options
     * @return ?UpdateProjectTierResponse
     * @throws BrumeException
     * @throws BrumeApiException
     */
    public function updateProjectTier(string $id, UpdateProjectTierRequest $request, ?array $options = null): ?UpdateProjectTierResponse
    {
        $options = array_merge($this->options, $options ?? []);
        try {
            $response = $this->client->sendRequest(
                new JsonApiRequest(
                    baseUrl: $options['baseUrl'] ?? $this->client->options['baseUrl'] ?? '',
                    path: "v1/projects/{$id}/tier",
                    method: HttpMethod::PATCH,
                    body: $request,
                ),
                $options,
            );
            $statusCode = $response->getStatusCode();
            if ($statusCode >= 200 && $statusCode < 400) {
                $json = $response->getBody()->getContents();
                if (empty($json)) {
                    return null;
                }
                return UpdateProjectTierResponse::fromJson($json);
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
