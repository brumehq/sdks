# frozen_string_literal: true

module Brume
  module Types
    class ConnectionInfo < Internal::Types::Model
      field :state, -> { Object }, optional: false, nullable: false

      field :updated_at, -> { String }, optional: false, nullable: false

      field :user_id, -> { String }, optional: false, nullable: false
    end
  end
end
