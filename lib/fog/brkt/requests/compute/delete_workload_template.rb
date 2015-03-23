module Fog
  module Compute
    class Brkt
      class Real
        def delete_workload_template(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/workloadtemplate/#{id}"
          )
        end
      end

      class Mock
        def delete_workload_template(id)
          self.data[:workload_templates].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
