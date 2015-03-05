require "fog/core/collection"
require "fog/brkt/models/compute/computing_cell"

module Fog
  module Compute
    class Brkt
      class ComputingCells < Fog::Collection
        model Fog::Compute::Brkt::ComputingCell

        def all
          raise NotImplementedError
        end
      end
    end
  end
end
