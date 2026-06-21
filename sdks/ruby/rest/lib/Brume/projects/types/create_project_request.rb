# frozen_string_literal: true

module Brume
  module Projects
    module Types
      class CreateProjectRequest < Internal::Types::Model
        field :name, -> { String }, optional: false, nullable: false
      end
    end
  end
end
