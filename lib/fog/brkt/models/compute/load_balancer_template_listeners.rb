require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_template_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplateListeners < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerTemplateListener

        # @return [LoadBalancerTemplate]
        attr_accessor :load_balancer_template

        # Get Load balancer template listeners for {#load_balancer_template}.
        # Requires {#load_balancer_template} attribute to be set.
        #
        # @return [Array<LoadBalancerTemplateListener>] load balancer template listeners
        def all
          requires :load_balancer_template
          load(service.list_load_balancer_template_listeners(load_balancer_template.id).body)
        end
      end
    end
  end
end
