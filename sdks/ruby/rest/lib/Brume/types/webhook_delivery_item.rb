# frozen_string_literal: true

module Brume
  module Types
    class WebhookDeliveryItem < Internal::Types::Model
      field :attempts, -> { Integer }, optional: false, nullable: false

      field :created_at, -> { String }, optional: false, nullable: false

      field :event_type, -> { String }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :last_attempt_at, -> { String }, optional: true, nullable: false

      field :response_status, -> { Integer }, optional: true, nullable: false

      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
