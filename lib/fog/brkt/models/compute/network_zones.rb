require "fog/core/collection"
require "fog/brkt/models/compute/network_zone"

module Fog
  module Compute
    class Brkt
      class NetworkZones < Fog::Collection
        model Fog::Compute::Brkt::NetworkZone

        attr_accessor :network

        def all(filter={})
          filter.merge!({:network_id => network.id}) unless network.nil?
          load(service.list_network_zones(filter).body)
        end
      end
    end
  end
end
