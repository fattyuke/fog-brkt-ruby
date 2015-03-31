require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerListeners < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerListener

        # @return [LoadBalancer] load balancer
        attr_accessor :load_balancer

        # Get load balancer listeners.
        # Requires {#load_balancer} attribute to be set.
        #
        # @return [Array<LoadBalancerListener>] load balancer listeners
        def all
          requires :load_balancer
          load(service.list_load_balancer_listeners(load_balancer.id).body)
        end
      end
    end
  end
end
