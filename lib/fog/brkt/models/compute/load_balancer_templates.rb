require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_template"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplates < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerTemplate

        # @return [WorkloadTemplate]
        attr_accessor :workload_template

        # Get load balancer templates.
        # If {#workload_template} attribute is set, returns only load balancer templates
        # scoped by workload template and returns all load balancer templates otherwise
        #
        # @return [Array<LoadBalancerTemplate>] load balancer templates
        def all
          instances = load(service.list_load_balancer_templates.body)
          if workload_template
            instances.select { |instance| instance.workload_template == workload_template.id }
          end
          instances
        end

        # Create a new instance of load balancer template.
        # If {#workload_template} attribute is set, sets {LoadBalancerTemplate#workload_template}
        # attribute to an {#workload_template}'s id
        #
        # @param [Hash] attributes load balancer template attributes
        # @return [LoadBalancerTemplate] load balancer template instance
        def new(attributes={})
          instance = super
          instance.workload_template = workload_template.id unless workload_template.nil?
          instance
        end
      end
    end
  end
end
