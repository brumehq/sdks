# frozen_string_literal: true

module Brume
  module Stats
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # Returns the project's analytics history as a list of snapshots
      # (oldest first). Snapshots are sampled every 30s in-process. The
      # response includes the last `window / interval` entries. Empty
      # state is an empty `snapshots` array — never faked data.
      #
      # Response body is documented as `additionalProperties: true` for
      # the same reason as `/v1/stats`: the shape is pinned by tests.
      #
      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [Integer, nil] :window_secs
      #
      # @return [Hash[String, Object]]
      def analytics(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        query_params = {}
        query_params["window_secs"] = params[:window_secs] if params.key?(:window_secs)

        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/analytics",
          query: query_params,
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

      # Returns project-level and global connection/channel statistics.
      #
      # Backwards compatibility: existing fields are preserved exactly. New
      # fields added in 2026-06-11 (latency, postgres_lag, dropped_messages,
      # slow_consumer_disconnections, dead_connections_cleaned,
      # auth_failures_last_minute, plan_limit_rejections, top_channels) are
      # additive — older dashboard clients keep working.
      #
      # Response body is documented as `additionalProperties: true` because
      # the exact JSON shape is pinned by ~10 unit tests in this file. A
      # future PR can type the envelope; for now SDK consumers will see
      # `Record<string, any>`.
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
      def get_stats(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/stats",
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
    end
  end
end
