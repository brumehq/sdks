# frozen_string_literal: true

module Brume
  module Types
    # `POST /v1/webhooks` success response. Includes the `secret` field
    # which is only returned at creation time.
    class WebhookCreatedResponse < Internal::Types::Model
      field :events, -> { Internal::Types::Array[String] }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :secret, -> { String }, optional: false, nullable: false

      field :url, -> { String }, optional: false, nullable: false
    end
  end
end
