module Fog
  module Compute
    class Brkt
      class Real
        def create_load_balancer_listener(attributes={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/loadbalancer/listener",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_load_balancer_listener(attributes={})
          attributes = Fog::StringifyKeys.stringify(attributes)
          id = Fog::Brkt::Mock.id
          data = {
            "id"                       => id,
            "name"                     => "listener HTTP:80 -> HTTP:80",
            "load_balancer"            => attributes["load_balancer"],
            "instance_protocol"        => attributes["instance_protocol"],
            "instance_port"            => attributes["instance_port"],
            "listener_protocol"        => attributes["listener_protocol"],
            "listener_port"            => attributes["listener_port"],
            "customer"                 => customer.id,
            "is_health_check_listener" => attributes["is_health_check_listener"],
            "stickiness"               => attributes["stickiness"],
            "modified_by"              => "user@example.com",
            "created_by"               => "user@example.com",
          }
          self.data[:load_balancer_listeners][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
