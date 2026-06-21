# frozen_string_literal: true

module Brume
  module Types
    # `GET /readyz` success body. The 200 / 503 distinction is what load
    # balancers key on; the body is for human debugging.
    class ReadyzResponse < Internal::Types::Model
      field :status, -> { String }, optional: false, nullable: false
    end
  end
end
