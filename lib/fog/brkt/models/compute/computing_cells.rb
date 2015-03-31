require "fog/core/collection"
require "fog/brkt/models/compute/computing_cell"

module Fog
  module Compute
    class Brkt
      class ComputingCells < Fog::Collection
        model Fog::Compute::Brkt::ComputingCell

        # Get computing cells
        #
        # @return [Array<ComputingCell>] computing cells
        def all
          load(service.list_computing_cells.body)
        end

        # Get computing cell by ID
        #
        # @param [String] id Computing cell id
        # @return [ComputingCell] computing cell
        def get(id)
          new(service.get_computing_cell(id).body)
        end
      end
    end
  end
end
