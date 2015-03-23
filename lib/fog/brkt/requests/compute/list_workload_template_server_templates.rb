module Fog
  module Compute
    class Brkt
      class Real
        def list_workload_template_server_templates(workload_template_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/workloadtemplate/#{workload_template_id}/instancetemplates"
          )
        end
      end

      class Mock
        def list_workload_template_server_templates(workload_template_id)
          response = Excon::Response.new
          response.body = self.data[:server_templates].select do |id, server_template_data|
            server_template_data["workload_template"] == workload_template_id
          end.map do |id, server_template_data|
            server_template_data
          end
          response
        end
      end
    end
  end
end
