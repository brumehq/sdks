# frozen_string_literal: true

module Brume
  module Types
    # `POST /v1/projects` success response. The `api_key` field is the only
    # time the raw key is returned; clients must store it immediately.
    class CreateProjectResponse < Internal::Types::Model
      field :api_key, -> { String }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :max_connections, -> { Integer }, optional: false, nullable: false

      field :name, -> { String }, optional: false, nullable: false

      field :tier, -> { String }, optional: false, nullable: false
    end
  end
end
