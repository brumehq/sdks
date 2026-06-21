# frozen_string_literal: true

module Brume
  module APIKeys
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # Returns a list of API keys for the authenticated project.
      #
      # @param request_options [Hash]
      # @param _params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::APIKeyListResponse]
      def list_api_keys(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/api-keys",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::APIKeyListResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Creates a new API key for the authenticated project.
      #
      # @param request_options [Hash]
      # @param params [Brume::APIKeys::Types::CreateAPIKeyRequest]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::CreateAPIKeyResponse]
      def create_api_key(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "POST",
          path: "v1/api-keys",
          body: Brume::APIKeys::Types::CreateAPIKeyRequest.new(params).to_h,
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::CreateAPIKeyResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Revokes an API key for the authenticated project.
      #
      # @param request_options [Hash]
      # @param params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :id
      #
      # @return [Brume::Types::RevokeAPIKeyResponse]
      def revoke_api_key(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "DELETE",
          path: "v1/api-keys/#{URI.encode_uri_component(params[:id].to_s)}",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::RevokeAPIKeyResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end
    end
  end
end
