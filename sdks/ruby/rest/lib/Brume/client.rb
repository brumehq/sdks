# frozen_string_literal: true

module Brume
  class BrumeClient
    # Returns the full operational picture for a project: counters,
    # latency percentiles, Postgres lag, top channels, and a plan-limit
    # snapshot. Project API key auth (any scope). No secrets, no
    # high-cardinality data, no admin gating.
    #
    # Response body is documented as `additionalProperties: true` for
    # the same reason as `/v1/stats` and `/v1/analytics`.
    #
    # @param request_options [Hash]
    # @param _params [Hash]
    # @option request_options [String] :base_url
    # @option request_options [Hash{String => Object}] :additional_headers
    # @option request_options [Hash{String => Object}] :additional_query_parameters
    # @option request_options [Hash{String => Object}] :additional_body_parameters
    # @option request_options [Integer] :timeout_in_seconds
    #
    # @return [Hash[String, Object]]
    def diagnostics(request_options: {}, **_params)
      request = Brume::Internal::JSON::Request.new(
        base_url: request_options[:base_url],
        method: "GET",
        path: "v1/diagnostics",
        request_options: request_options
      )
      begin
        response = @client.send(request)
      rescue Net::HTTPRequestTimeout
        raise Brume::Errors::TimeoutError
      end
      code = response.code.to_i
      return if code.between?(200, 299)

      error_class = Brume::Errors::ResponseError.subclass_for_code(code)
      raise error_class.new(response.body, code: code)
    end

    # @param base_url [String, nil]
    # @param token [String]
    # @param max_retries [Integer]
    #
    # @return [void]
    def initialize(base_url: nil, token: ENV.fetch("BRUME_API_KEY", nil), max_retries: 2)
      @raw_client = Brume::Internal::Http::RawClient.new(
        base_url: base_url,
        headers: {
          "X-Fern-Language" => "Ruby",
          Authorization: "Bearer #{token}"
        },
        max_retries: max_retries
      )
    end

    # @return [Brume::Public::Client]
    def public
      @public ||= Brume::Public::Client.new(client: @raw_client)
    end

    # @return [Brume::Stats::Client]
    def stats
      @stats ||= Brume::Stats::Client.new(client: @raw_client)
    end

    # @return [Brume::APIKeys::Client]
    def api_keys
      @api_keys ||= Brume::APIKeys::Client.new(client: @raw_client)
    end

    # @return [Brume::Channels::Client]
    def channels
      @channels ||= Brume::Channels::Client.new(client: @raw_client)
    end

    # @return [Brume::Longpoll::Client]
    def longpoll
      @longpoll ||= Brume::Longpoll::Client.new(client: @raw_client)
    end

    # @return [Brume::Postgres::Client]
    def postgres
      @postgres ||= Brume::Postgres::Client.new(client: @raw_client)
    end

    # @return [Brume::Projects::Client]
    def projects
      @projects ||= Brume::Projects::Client.new(client: @raw_client)
    end

    # @return [Brume::Sse::Client]
    def sse
      @sse ||= Brume::Sse::Client.new(client: @raw_client)
    end

    # @return [Brume::Webhooks::Client]
    def webhooks
      @webhooks ||= Brume::Webhooks::Client.new(client: @raw_client)
    end
  end
end
