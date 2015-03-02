require "fog/core/collection"
require "fog/brkt/models/compute/workload"

module Fog
  module Compute
    class Brkt
      class Workloads < Fog::Collection
        model Fog::Compute::Brkt::Workload
      end
    end
  end
end
