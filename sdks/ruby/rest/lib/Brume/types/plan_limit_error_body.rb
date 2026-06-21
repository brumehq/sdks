# frozen_string_literal: true

module Brume
  module Types
    # `PLAN_LIMIT` error body. Emitted by the publish / create-project /
    # create-key / SSE / long-poll paths when the project hits a per-axis
    # cap. The `code` is always `"PLAN_LIMIT"`; the `reason` is a closed
    # enum string SDK consumers can pattern-match on.
    class PlanLimitErrorBody < Internal::Types::Model
      field :code, -> { String }, optional: false, nullable: false

      field :current, -> { Integer }, optional: false, nullable: false

      field :limit, -> { Integer }, optional: true, nullable: false

      field :message, -> { String }, optional: false, nullable: false

      field :reason, -> { String }, optional: false, nullable: false

      field :upgrade_tier, -> { String }, optional: true, nullable: false, api_name: "upgradeTier"
    end
  end
end
