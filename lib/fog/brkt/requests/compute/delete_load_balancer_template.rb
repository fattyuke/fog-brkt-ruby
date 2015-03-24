module Fog
  module Compute
    class Brkt
      class Real
        def delete_load_balancer_template(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/loadbalancertemplate/#{id}"
          )
        end
      end

      class Mock
        def delete_load_balancer_template(id)
          self.data[:load_balancer_templates].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
