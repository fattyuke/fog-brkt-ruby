module Fog
  module Compute
    class Brkt
      class Real
        def create_load_balancer_template(attributes={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/loadbalancertemplate",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_load_balancer_template(attributes={})
          attributes = Fog::StringifyKeys.stringify(attributes)
          id = Fog::Brkt::Mock.id
          data = {
            "id"                    => id,
            "name"                  => attributes["name"],
            "description"           => "",
            "service_name"          => attributes["service_name"] || "",
            "workload_template"     => attributes["workload_template"],
            "security_group"        => nil,
            "customer"              => customer.id,
            "healthy_threshold"     => 10,
            "unhealthy_threshold"   => 2,
            "health_check_timeout"  => 5,
            "health_check_interval" => 30,
            "health_check_listener" => nil,
            "health_check_target"   => "/",
            "created_by"            => "user@example.com",
            "created_time"          => "2015-03-24T18:55:05.757490+00:00",
            "modified_by"           => "user@example.com",
            "modified_time"         => "2015-03-24T18:55:05.757518+00:00",
            "fixed_charge"          => "0.00",
            "base_hourly_rate"      => "0.00000",
            "hourly_cost"           => "0.00",
            "daily_cost"            => "0.00",
            "monthly_cost"          => "0.00",
            "state"                 => "PUBLISHED",
            "metadata"              => {}
          }
          self.data[:load_balancer_templates][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
