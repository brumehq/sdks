# frozen_string_literal: true

module Brume
  module APIKeys
    module Types
      class CreateAPIKeyRequest < Internal::Types::Model
        field :environment, -> { String }, optional: false, nullable: false

        field :label, -> { String }, optional: false, nullable: false

        field :scopes, -> { Internal::Types::Array[Brume::Types::APIKeyScope] }, optional: true, nullable: false
      end
    end
  end
end
