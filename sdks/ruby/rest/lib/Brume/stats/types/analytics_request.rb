# frozen_string_literal: true

module Brume
  module Stats
    module Types
      class AnalyticsRequest < Internal::Types::Model
        field :window_secs, -> { Integer }, optional: true, nullable: false
      end
    end
  end
end
