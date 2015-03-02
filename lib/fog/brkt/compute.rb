require "fog/brkt/core"

module Fog
  module Compute
    class Brkt < Fog::Service
      model_path "fog/brkt/models/compute"

      model      :server
      collection :servers
      model      :workload
      collection :workloads

      class Real
        def initialize(options={})
        end
      end

      class Mock
        def initialize(options={})
        end
      end
    end
  end
end
