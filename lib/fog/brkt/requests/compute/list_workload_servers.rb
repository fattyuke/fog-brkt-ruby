module Fog
  module Compute
    class Brkt
      class Real
        def list_workload_servers(workload_id)
          request(
            :expects => [200],
            :path    => "v2/api/config/workload/#{workload_id}/instance"
          )
        end
      end

      class Mock
        def list_workload_servers(workload_id)
          response = Excon::Response.new
          data = self.data[:servers].select do |server_id, server_data|
            server_data["workload"] == workload_id
          end.map { |server_id, server_data| server_data }
          response.body = data
          response
        end
      end
    end
  end
end
