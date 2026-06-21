# frozen_string_literal: true

module Brume
  module Types
    # `PATCH /v1/projects/:id/tier` success response.
    class UpdateProjectTierResponse < Internal::Types::Model
      field :id, -> { String }, optional: false, nullable: false

      field :max_connections, -> { Integer }, optional: false, nullable: false

      field :tier, -> { String }, optional: false, nullable: false
    end
  end
end
