module Fog
  module Compute
    class Brkt
      class Real
        def list_load_balancer_listeners(lb_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/loadbalancer/#{lb_id}/listeners"
          )
        end
      end

      class Mock
        def list_load_balancer_listeners(lb_id)
          listeners = data[:load_balancer_listeners].select do |id, listener_data|
            listener_data["load_balancer"] == lb_id
          end.map do |id, listener_data|
            listener_data
          end
          Excon::Response.new(:body => listeners)
        end
      end
    end
  end
end
