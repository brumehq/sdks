# frozen_string_literal: true

module Brume
  module Types
    # Standard error response body returned by all REST endpoints on 4xx/5xx.
    #
    # The legacy handlers emit `{"error": "..."}` (string-only). The newer
    # handlers emit `{"error": "CODE", "message": "human-readable"}`. Both
    # shapes parse into this struct; the `message` field is optional for
    # back-compat.
    class ErrorBody < Internal::Types::Model
      field :error, -> { String }, optional: false, nullable: false

      field :message, -> { String }, optional: true, nullable: false
    end
  end
end
