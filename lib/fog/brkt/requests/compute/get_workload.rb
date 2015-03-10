module Fog
  module Compute
    class Brkt
      class Real
        def get_workload(id)
          request(
            :expects => [200],
            :path    => "v2/api/config/workload/#{id}"
          )
        end
      end

      class Mock
        def get_workload(id)
          Excon::Response.new(:body => self.data[:workloads][id])
        end
      end
    end
  end
end
