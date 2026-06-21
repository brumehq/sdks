# frozen_string_literal: true

module Brume
  module Types
    class WebhookSummary < Internal::Types::Model
      field :created_at, -> { String }, optional: false, nullable: false

      field :events, -> { Internal::Types::Array[String] }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :url, -> { String }, optional: false, nullable: false
    end
  end
end
