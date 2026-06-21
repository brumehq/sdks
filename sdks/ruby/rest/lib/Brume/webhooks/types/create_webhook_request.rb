# frozen_string_literal: true

module Brume
  module Webhooks
    module Types
      class CreateWebhookRequest < Internal::Types::Model
        field :events, -> { Internal::Types::Array[String] }, optional: false, nullable: false

        field :url, -> { String }, optional: false, nullable: false
      end
    end
  end
end
