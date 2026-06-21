# frozen_string_literal: true

module Brume
  module Types
    # `POST /v1/webhooks/:id/test` success response.
    class WebhookTestResponse < Internal::Types::Model
      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
