# frozen_string_literal: true

module Brume
  module Webhooks
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # @param request_options [Hash]
      # @param _params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::WebhookListResponse]
      def list(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/webhooks",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::WebhookListResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # @param request_options [Hash]
      # @param params [Brume::Webhooks::Types::CreateWebhookRequest]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::WebhookCreatedResponse]
      def create(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "POST",
          path: "v1/webhooks",
          body: Brume::Webhooks::Types::CreateWebhookRequest.new(params).to_h,
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::WebhookCreatedResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :id
      #
      # @return [Brume::Types::WebhookDeleteResponse]
      def delete(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "DELETE",
          path: "v1/webhooks/#{URI.encode_uri_component(params[:id].to_s)}",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::WebhookDeleteResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :id
      #
      # @return [Brume::Types::WebhookDeliveryListResponse]
      def list_deliveries(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/webhooks/#{URI.encode_uri_component(params[:id].to_s)}/deliveries",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::WebhookDeliveryListResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :id
      #
      # @return [Brume::Types::WebhookTestResponse]
      def test(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "POST",
          path: "v1/webhooks/#{URI.encode_uri_component(params[:id].to_s)}/test",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::WebhookTestResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end
    end
  end
end
