module Fog
  module Compute
    class Brkt
      class Real
        def delete_load_balancer(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/loadbalancer/#{id}"
          )
        end
      end

      class Mock
        def delete_load_balancer(id)
          response = Excon::Response.new
          self.data[:load_balancers].delete(id)
          response
        end
      end
    end
  end
end
