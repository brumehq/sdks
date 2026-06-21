# frozen_string_literal: true

module Brume
  module Types
    # `GET /readyz` failure body (HTTP 503).
    class NotReadyResponse < Internal::Types::Model
      field :reason, -> { String }, optional: false, nullable: false

      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
