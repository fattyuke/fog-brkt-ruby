module Fog
  module Compute
    class Brkt
      class Real
        def list_workloads
          request(
            :expects => [200],
            :path    => "v1/api/config/workload"
          )
        end
      end

      class Mock
        def list_workloads
          response = Excon::Response.new
          response.body = self.data[:workloads].map do |id, workload_data|
            workload_data
          end
          response
        end
      end
    end
  end
end

