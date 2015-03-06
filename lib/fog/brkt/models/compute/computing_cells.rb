require "fog/core/collection"
require "fog/brkt/models/compute/computing_cell"

module Fog
  module Compute
    class Brkt
      class ComputingCells < Fog::Collection
        model Fog::Compute::Brkt::ComputingCell

        def all
          load(service.list_computing_cells.body)
        end

        def get(id)
          new(service.get_computing_cell(id).body)
        end
      end
    end
  end
end
