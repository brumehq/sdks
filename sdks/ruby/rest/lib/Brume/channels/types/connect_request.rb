# frozen_string_literal: true

module Brume
  module Channels
    module Types
      class ConnectRequest < Internal::Types::Model
        field :token, -> { String }, optional: true, nullable: false
      end
    end
  end
end
