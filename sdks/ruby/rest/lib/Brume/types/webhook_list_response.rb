# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/webhooks` success response.
    class WebhookListResponse < Internal::Types::Model
      field :webhooks, -> { Internal::Types::Array[Brume::Types::WebhookSummary] }, optional: false, nullable: false
    end
  end
end
