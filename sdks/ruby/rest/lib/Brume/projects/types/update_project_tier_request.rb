# frozen_string_literal: true

module Brume
  module Projects
    module Types
      class UpdateProjectTierRequest < Internal::Types::Model
        field :id, -> { String }, optional: false, nullable: false

        field :tier, -> { String }, optional: false, nullable: false
      end
    end
  end
end
