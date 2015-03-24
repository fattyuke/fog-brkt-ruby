module Fog
  module Compute
    class Brkt
      class Real
        def list_load_balancer_templates
          request(
            :expects => [200],
            :path    => "v1/api/config/loadbalancertemplate"
          )
        end
      end

      class Mock
        def list_load_balancer_templates
          response = Excon::Response.new
          response.body = self.data[:load_balancer_templates].map { |id, lb_tpl_data| lb_tpl_data }
          response
        end
      end
    end
  end
end
