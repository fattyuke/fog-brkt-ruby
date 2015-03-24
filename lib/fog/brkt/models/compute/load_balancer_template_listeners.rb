require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_template_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplateListeners < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerTemplateListener

        attr_accessor :load_balancer_template

        def all
          requires :load_balancer_template
          load(service.list_load_balancer_template_listeners(load_balancer_template.id).body)
        end

        def get(id)
          raise NotImplementedError
        end
      end
    end
  end
end
