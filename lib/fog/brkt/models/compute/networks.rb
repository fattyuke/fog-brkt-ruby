require "fog/core/collection"
require "fog/brkt/models/compute/network"

module Fog
  module Compute
    class Brkt
      class Networks < Fog::Collection
        model Fog::Compute::Brkt::Network

        def all
          load(service.list_networks.body)
        end

        def get(id)
          new(service.get_network(id).body)
        end
      end
    end
  end
end
