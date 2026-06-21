# frozen_string_literal: true

module Brume
  module Types
    class APIKeyListItem < Internal::Types::Model
      field :environment, -> { String }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :label, -> { String }, optional: false, nullable: false

      field :last_used_at, -> { String }, optional: true, nullable: false

      field :prefix, -> { String }, optional: false, nullable: false

      field :scopes, -> { Internal::Types::Array[Brume::Types::APIKeyScope] }, optional: false, nullable: false
    end
  end
end
