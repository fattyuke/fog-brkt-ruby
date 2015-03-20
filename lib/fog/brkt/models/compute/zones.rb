require "fog/core/collection"
require "fog/brkt/models/compute/zone"

module Fog
  module Compute
    class Brkt
      class Zones < Fog::Collection
        model Fog::Compute::Brkt::Zone

        attr_accessor :network

        def all
          if network.nil?
            load(service.list_zones.body)
          else
            zones = load(service.list_network_zones(network.id).body)
            zones.each { |zone| zone.network = network }
          end
        end

        def new(arguments={})
          instance = super(arguments)
          instance.network = network if network
          instance
        end
      end
    end
  end
end
