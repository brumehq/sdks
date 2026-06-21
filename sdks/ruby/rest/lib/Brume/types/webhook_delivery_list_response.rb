# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/webhooks/:id/deliveries` success response.
    class WebhookDeliveryListResponse < Internal::Types::Model
      field :deliveries, -> { Internal::Types::Array[Brume::Types::WebhookDeliveryItem] }, optional: false, nullable: false
    end
  end
end
