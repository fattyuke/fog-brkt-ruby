require "fog/core/collection"
require "fog/brkt/models/compute/network"

module Fog
  module Compute
    class Brkt
      class Networks < Fog::Collection
        model Fog::Compute::Brkt::Network

        # Get networks
        #
        # @return [Array<Network>] networks
        def all
          load(service.list_networks.body)
        end

        # Get network by ID
        #
        # @param [String] id network id
        # @return [Network] network
        def get(id)
          new(service.get_network(id).body)
        end
      end
    end
  end
end
