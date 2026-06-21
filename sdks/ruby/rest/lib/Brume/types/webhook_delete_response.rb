# frozen_string_literal: true

module Brume
  module Types
    # `DELETE /v1/webhooks/:id` success response.
    class WebhookDeleteResponse < Internal::Types::Model
      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
