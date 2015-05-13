module Fog
  module Compute
    class Brkt
      class Real
        def list_workload_load_balancers(workload_id, filter = {})
          filter[:workload] = workload_id
          request(
            :expects => [200],
            :path    => "v2/api/config/loadbalancer",
            :query   => filter
          )
        end
      end

      class Mock
        def list_workload_load_balancers(workload_id, filter = {})
          response = Excon::Response.new
          data = self.data[:load_balancers].select do |lb_id, lb_data|
            lb_data["workload"] == workload_id
          end.map { |lb_id, lb_data| lb_data }
          response.body = data
          response
        end
      end
    end
  end
end
