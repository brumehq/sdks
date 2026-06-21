# frozen_string_literal: true

module Brume
  module Channels
    module Types
      class PublishRequest < Internal::Types::Model
        field :channel, -> { String }, optional: false, nullable: false

        field :event, -> { String }, optional: false, nullable: false

        field :payload, -> { Internal::Types::Hash[String, Object] }, optional: false, nullable: false

        field :ref, -> { String }, optional: true, nullable: false
      end
    end
  end
end
