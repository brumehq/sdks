# frozen_string_literal: true

module Brume
  module Types
    # `POST /v1/api-keys` success response. The `key` field is the raw
    # key returned exactly once; clients must store it before navigating
    # away.
    class CreateAPIKeyResponse < Internal::Types::Model
      field :environment, -> { String }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :key, -> { String }, optional: false, nullable: false

      field :label, -> { String }, optional: false, nullable: false

      field :prefix, -> { String }, optional: false, nullable: false

      field :scopes, -> { Internal::Types::Array[Brume::Types::APIKeyScope] }, optional: false, nullable: false
    end
  end
end
