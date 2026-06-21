# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/api-keys` success response.
    class APIKeyListResponse < Internal::Types::Model
      field :api_keys, -> { Internal::Types::Array[Brume::Types::APIKeyListItem] }, optional: false, nullable: false
    end
  end
end
