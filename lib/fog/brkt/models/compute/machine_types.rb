require "fog/core/collection"
require "fog/brkt/models/compute/machine_type"

module Fog
  module Compute
    class Brkt
      class MachineTypes < Fog::Collection
        model Fog::Compute::Brkt::MachineType

        def all
          load(service.list_machine_types.body)
        end
      end
    end
  end
end
