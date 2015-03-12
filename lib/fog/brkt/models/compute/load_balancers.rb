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
          raise NotImplementedError
        end
      end
    end
  end
end
