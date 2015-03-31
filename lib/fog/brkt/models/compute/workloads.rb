require "fog/core/collection"
require "fog/brkt/models/compute/workload"

module Fog
  module Compute
    class Brkt
      class Workloads < Fog::Collection
        model Fog::Compute::Brkt::Workload

        # Get workloads
        #
        # @return [Array<Workload>] workloads
        def all
          load(service.list_workloads.body)
        end

        # Get workload by ID
        #
        # @param [String] id workload id
        # @return [Workload] workload
        def get(id)
          new(service.get_workload(id).body)
        end
      end
    end
  end
end
