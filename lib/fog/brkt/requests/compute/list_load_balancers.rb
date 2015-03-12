module Fog
  module Compute
    class Brkt
      class Real
        def list_load_balancers
          request(
            :expects => [200],
            :path    => "v1/api/config/loadbalancer"
          )
        end
      end

      class Mock
        def list_load_balancers
          response = Excon::Response.new
          response.body = self.data[:load_balancers].map { |id, lb_data| lb_data }
          response
        end
      end
    end
  end
end
