module Fog
  module Compute
    class Brkt
      class Real
        def get_load_balancer(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/loadbalancer/#{id}"
          )
        end
      end

      class Mock
        def get_load_balancer(id)
          Excon::Response.new(:body => self.data[:load_balancers][id])
        end
      end
    end
  end
end
