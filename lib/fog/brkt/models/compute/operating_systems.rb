require "fog/core/collection"
require "fog/brkt/models/compute/operating_system"

module Fog
  module Compute
    class Brkt
      class OperatingSystems < Fog::Collection
        model Fog::Compute::Brkt::OperatingSystem

        def all
          load(service.list_operating_systems.body)
        end

        def get(id)
          new(service.get_operating_system(id).body)
        end
      end
    end
  end
end
