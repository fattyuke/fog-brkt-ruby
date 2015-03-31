require "fog/core/collection"
require "fog/brkt/models/compute/workload"

module Fog
  module Compute
    class Brkt
      class WorkloadTemplates < Fog::Collection
        model Fog::Compute::Brkt::WorkloadTemplate

        # Get workload templates
        #
        # @return [Array<WorkloadTemple>] workload templates
        def all
          load(service.list_workload_templates.body)
        end

        # Get workload template by ID
        #
        # @param [String] id workload template id
        # @return [WorkloadTemplate] workload template
        def get(id)
          new(service.get_workload_template(id).body)
        end
      end
    end
  end
end
