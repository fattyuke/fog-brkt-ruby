require "fog/core/collection"
require "fog/brkt/models/compute/server_template"

module Fog
  module Compute
    class Brkt
      class ServerTemplates < Fog::Collection
        model Fog::Compute::Brkt::ServerTemplate

        attr_accessor :workload_template

        def all
          requires :workload_template
          load(service.list_workload_template_server_templates(workload_template.id).body)
        end

        def get(id)
          new(service.get_server_template(id).body)
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
