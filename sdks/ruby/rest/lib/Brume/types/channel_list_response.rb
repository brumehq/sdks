# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/channels` success response.
    class ChannelListResponse < Internal::Types::Model
      field :channels, -> { Internal::Types::Array[Brume::Types::ChannelSummary] }, optional: false, nullable: false
    end
  end
end
