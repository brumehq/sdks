# frozen_string_literal: true

module Brume
  module Internal
    module Types
      module Unknown
        include Brume::Internal::Types::Type

        def coerce(value)
          value
        end
      end
    end
  end
end
