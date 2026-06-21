# frozen_string_literal: true

module Brume
  module Types
    module APIKeyScope
      extend Brume::Internal::Types::Enum

      PUBLISH = "publish"
      READ_STATS = "read_stats"
      MANAGE_KEYS = "manage_keys"
      MANAGE_PROJECT = "manage_project"
    end
  end
end
