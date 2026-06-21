# frozen_string_literal: true

module Brume
  module Types
    # `DELETE /v1/api-keys/:id` success response.
    class RevokeAPIKeyResponse < Internal::Types::Model
      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
