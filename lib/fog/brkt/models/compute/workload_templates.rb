require "fog/core/collection"
require "fog/brkt/models/compute/workload"

module Fog
  module Compute
    class Brkt
      class WorkloadTemplates < Fog::Collection
        model Fog::Compute::Brkt::WorkloadTemplate

        def all
          load(service.list_workload_templates.body)
        end

        def get(id)
          new(service.get_workload_template(id).body)
        end
      end
    end
  end
end
