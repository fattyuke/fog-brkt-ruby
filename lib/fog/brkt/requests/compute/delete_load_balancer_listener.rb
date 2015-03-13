module Fog
  module Compute
    class Brkt
      class Real
        def delete_load_balancer_listener(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/loadbalancer/listener/#{id}"
          )
        end
      end

      class Mock
        def delete_load_balancer_listener(id)
          self.data[:load_balancer_listeners].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
