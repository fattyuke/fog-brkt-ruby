require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerListeners < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerListener

        attr_accessor :load_balancer

        def all
          requires :load_balancer
          load(service.list_load_balancer_listeners(load_balancer.id).body)
        end

        def get(id)
          raise NotImplementedError
        end
      end
    end
  end
end
