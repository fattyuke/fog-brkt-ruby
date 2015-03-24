require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer_template"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplates < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancerTemplate

        attr_accessor :workload_template

        def all
          instances = load(service.list_load_balancer_templates.body)
          if workload_template
            instances.select { |instance| instance.workload_template == workload_template.id }
          end
          instances
        end

        def get(id)
          raise NotImplementedError
        end

        def new(attributes={})
          instance = super
          instance.workload_template = workload_template.id unless workload_template.nil?
          instance
        end
      end
    end
  end
end
