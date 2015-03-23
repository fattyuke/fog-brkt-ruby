module Fog
  module Compute
    class Brkt
      class Real
        def list_workload_templates
          request(
            :expects => [200],
            :path    => "v1/api/config/workloadtemplate"
          )
        end
      end

      class Mock
        def list_workload_templates
          response = Excon::Response.new
          response.body = self.data[:workload_templates].map do |id, workload_template_data|
            workload_template_data
          end
          response
        end
      end
    end
  end
end

