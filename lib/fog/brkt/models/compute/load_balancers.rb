require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer"

module Fog
  module Compute
    class Brkt
      class LoadBalancers < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancer

        # Get load balancers.
        #
        # @return [Array<LoadBalancer>] load balancers
        def all
          load(service.list_load_balancers.body)
        end

        # Get load balancer by ID
        #
        # @param [String] id load balancer id
        # @return [LoadBalancer] load balancer
        def get(id)
          new(service.get_load_balancer(id).body)
        end
      end
    end
  end
end
