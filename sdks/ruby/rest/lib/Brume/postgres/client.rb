# frozen_string_literal: true

module Brume
  module Postgres
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # Returns the operational state of the Postgres WAL logical
      # replication slot for the authenticated project. Project API key
      # auth (any scope). The doctor reads the gateway's in-process cache
      # — the numbers reflect the gateway that handled the request, not
      # a globally-consistent cluster view.
      #
      # Response body is documented as `additionalProperties: true` for
      # the same reason as `/v1/stats`.
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
      def doctor(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/postgres/doctor",
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
