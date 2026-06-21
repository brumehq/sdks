# frozen_string_literal: true

module Brume
  module Types
    # `POST /v1/channels/:channel/publish` success response.
    class PublishResponse < Internal::Types::Model
      field :channel, -> { String }, optional: false, nullable: false

      field :event, -> { String }, optional: false, nullable: false

      field :recipients, -> { Integer }, optional: false, nullable: false

      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
