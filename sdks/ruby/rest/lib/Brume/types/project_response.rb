# frozen_string_literal: true

module Brume
  module Types
    # `GET /v1/project` success response.
    class ProjectResponse < Internal::Types::Model
      field :created_at, -> { String }, optional: false, nullable: false

      field :id, -> { String }, optional: false, nullable: false

      field :max_connections, -> { Integer }, optional: false, nullable: false

      field :name, -> { String }, optional: false, nullable: false

      field :tier, -> { String }, optional: false, nullable: false
    end
  end
end
