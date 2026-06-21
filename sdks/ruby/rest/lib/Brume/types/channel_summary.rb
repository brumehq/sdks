# frozen_string_literal: true

module Brume
  module Types
    class ChannelSummary < Internal::Types::Model
      field :id, -> { String }, optional: false, nullable: false

      field :name, -> { String }, optional: false, nullable: false
    end
  end
end
