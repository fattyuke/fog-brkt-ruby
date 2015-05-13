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

        # Create a new instance of a load balancer listener
        # If {#load_balancer} attribute is set, sets
        # {LoadBalancerListener#load_balancer} attribute
        # to a {#load_balancer}'s id
        #
        # @param [Hash] attributes load balancer listener attributes
        # @return [LoadBalancerListener] LoadBalancerListener instance
        def new(attributes={})
          requires :load_balancer
          super({:load_balancer => load_balancer.id}.merge(attributes))
        end
      end
    end
  end
end
