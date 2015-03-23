module Fog
  module Compute
    class Brkt
      class Real
        def get_workload_template(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/workloadtemplate/#{id}"
          )
        end
      end

      class Mock
        def get_workload_template(id)
          Excon::Response.new(:body => self.data[:workload_templates][id])
        end
      end
    end
  end
end
