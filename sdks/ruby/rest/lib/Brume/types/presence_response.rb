# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/channels/:channel/presence` success response.
    class PresenceResponse < Internal::Types::Model
      field :channel, -> { String }, optional: false, nullable: false

      field :connection_count, -> { Integer }, optional: false, nullable: false

      field :presence, -> { Internal::Types::Array[Brume::Types::ConnectionInfo] }, optional: false, nullable: false
    end
  end
end
