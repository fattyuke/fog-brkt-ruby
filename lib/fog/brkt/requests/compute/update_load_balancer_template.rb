module Fog
  module Compute
    class Brkt
      class Real
        def update_load_balancer_template(id, attributes={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/loadbalancertemplate/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_load_balancer_template(id, attributes={})
          attributes = Fog::StringifyKeys.stringify(attributes)
          self.data[:load_balancer_templates][id].merge!(attributes)
          Excon::Response.new(:body => self.data[:load_balancer_templates][id])
        end
      end
    end
  end
end
