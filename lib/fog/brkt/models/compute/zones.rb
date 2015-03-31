require "fog/core/collection"
require "fog/brkt/models/compute/zone"

module Fog
  module Compute
    class Brkt
      class Zones < Fog::Collection
        model Fog::Compute::Brkt::Zone

        # @return [Network]
        attr_accessor :network

        # Get network zones.
        # If {#network} attribute is set, returns only zones
        # scoped by network and returns all zones otherwise
        #
        # @return [Array<Zone>] zones
        def all
          if network.nil?
            load(service.list_zones.body)
          else
            load(service.list_network_zones(network.id).body)
          end
        end
      end
    end
  end
end
