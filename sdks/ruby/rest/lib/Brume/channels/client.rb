# frozen_string_literal: true

module Brume
  module Channels
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # Returns a list of all channels for the authenticated project.
      #
      # @param request_options [Hash]
      # @param _params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::ChannelListResponse]
      def list_channels(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/channels",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::ChannelListResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Returns the current presence roster for a channel.
      #
      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :channel
      #
      # @return [Brume::Types::PresenceResponse]
      def get_presence(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/channels/#{URI.encode_uri_component(params[:channel].to_s)}/presence",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::PresenceResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Server-side REST publish endpoint for non-WebSocket backends
      # (cron jobs, webhooks, queue workers).
      #
      # @param request_options [Hash]
      # @param params [Brume::Channels::Types::PublishRequest]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :channel
      #
      # @return [Brume::Types::PublishResponse]
      def publish(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request_data = Brume::Channels::Types::PublishRequest.new(params).to_h
        non_body_param_names = %w[channel]
        body = request_data.except(*non_body_param_names)

        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "POST",
          path: "v1/channels/#{URI.encode_uri_component(params[:channel].to_s)}/publish",
          body: body,
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::PublishResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # JWT extraction priority:
      # 1. `Sec-WebSocket-Protocol: brume.token.<jwt>` (recommended — keeps the
      #    token out of access logs, browser history, and referer headers).
      # 2. `?token=<jwt>` query parameter (legacy; emits a deprecation warning).
      #
      # If auth fails, returns an HTTP error response without upgrading.
      #
      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String, nil] :token
      #
      # @return [untyped]
      def connect(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        query_params = {}
        query_params["token"] = params[:token] if params.key?(:token)

        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/connect",
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
    end
  end
end
