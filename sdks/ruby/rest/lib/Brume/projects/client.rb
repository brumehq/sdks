# frozen_string_literal: true

module Brume
  module Projects
    class Client
      # @param client [Brume::Internal::Http::RawClient]
      #
      # @return [void]
      def initialize(client:)
        @client = client
      end

      # Returns full project info for the dashboard.
      #
      # @param request_options [Hash]
      # @param _params [Hash]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::ProjectResponse]
      def get_project(request_options: {}, **_params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "GET",
          path: "v1/project",
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::ProjectResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Creates a new project with an initial API key. Gated on email verification.
      #
      # @param request_options [Hash]
      # @param params [Brume::Projects::Types::CreateProjectRequest]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      #
      # @return [Brume::Types::CreateProjectResponse]
      def create_project(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "POST",
          path: "v1/projects",
          body: Brume::Projects::Types::CreateProjectRequest.new(params).to_h,
          request_options: request_options
        )
        begin
          response = @client.send(request)
        rescue Net::HTTPRequestTimeout
          raise Brume::Errors::TimeoutError
        end
        code = response.code.to_i
        if code.between?(200, 299)
          Brume::Types::CreateProjectResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end

      # Internal sync endpoint used by the dashboard after Polar.sh webhook
      # processing. Gated by `BRUME_INTERNAL_TOKEN`.
      #
      # @param request_options [Hash]
      # @param params [Brume::Projects::Types::UpdateProjectTierRequest]
      # @option request_options [String] :base_url
      # @option request_options [Hash{String => Object}] :additional_headers
      # @option request_options [Hash{String => Object}] :additional_query_parameters
      # @option request_options [Hash{String => Object}] :additional_body_parameters
      # @option request_options [Integer] :timeout_in_seconds
      # @option params [String] :id
      #
      # @return [Brume::Types::UpdateProjectTierResponse]
      def update_project_tier(request_options: {}, **params)
        params = Brume::Internal::Types::Utils.normalize_keys(params)
        request_data = Brume::Projects::Types::UpdateProjectTierRequest.new(params).to_h
        non_body_param_names = %w[id]
        body = request_data.except(*non_body_param_names)

        request = Brume::Internal::JSON::Request.new(
          base_url: request_options[:base_url],
          method: "PATCH",
          path: "v1/projects/#{URI.encode_uri_component(params[:id].to_s)}/tier",
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
          Brume::Types::UpdateProjectTierResponse.load(response.body)
        else
          error_class = Brume::Errors::ResponseError.subclass_for_code(code)
          raise error_class.new(response.body, code: code)
        end
      end
    end
  end
end
