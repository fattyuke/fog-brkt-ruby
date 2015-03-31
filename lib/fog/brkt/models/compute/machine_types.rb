require "fog/core/collection"
require "fog/brkt/models/compute/machine_type"

module Fog
  module Compute
    class Brkt
      class MachineTypes < Fog::Collection
        model Fog::Compute::Brkt::MachineType

        # Get machine types
        #
        # @return [Array<MachineType>] machine types
        def all
          load(service.list_machine_types.body)
        end

        # Get machine type by ID
        #
        # @param [String] id machine type id
        # @return [MachineType] machine type
        def get(id)
          all.find { |machine_type| machine_type.id == id }
        end
      end
    end
  end
end
