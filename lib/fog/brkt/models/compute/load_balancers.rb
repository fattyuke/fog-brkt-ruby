require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer"

module Fog
  module Compute
    class Brkt
      class LoadBalancers < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancer

        def all
          load(service.list_load_balancers.body)
        end

        def get(id)
          new(service.get_load_balancer(id).body)
        end
      end
    end
  end
end
