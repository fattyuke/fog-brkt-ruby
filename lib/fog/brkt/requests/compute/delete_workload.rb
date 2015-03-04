module Fog
  module Compute
    class Brkt
      class Real
        def delete_workload(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v2/api/config/workload/#{id}"
          )
        end
      end

      class Mock
        def delete_workload(id)
          response = Excon::Response.new
          self.data[:workloads].delete(id)
          response
        end
      end
    end
  end
end
