module Fog
  module Compute
    class Brkt
      class Real
        def create_load_balancer(options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/loadbalancer",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_load_balancer(options={})
          options = Fog::StringifyKeys.stringify(options)
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          workload_id = options["workload"]
          data = {
            "id"                       => id,
            "customer"                 => customer.id,
            "name"                     => options["name"],
            "workload"                 => workload_id,
            "billing_group"            => self.data[:workloads][workload_id]["billing_group"],
            "security_group"           => options["security_group"],
            "daily_cost"               => "0.00",
            "description"              => "",
            "service_name_fqdn"        => nil,
            "service_name"             => "",
            "healthy_threshold"        => 10,
            "modified_time"            => "2015-03-12T16:56:46.954640+00:00",
            "unhealthy_threshold"      => 2,
            "cost"                     => "0.00",
            "created_by"               => "user@example.com",
            "created_time"             => "2015-03-12T16:56:46.954612+00:00",
            "fixed_charge"             => "0.00",
            "base_hourly_rate"         => "0.00000",
            "health_check_target"      => "/",
            "modified_by"              => "user@example.com",
            "requested_state"          => "AVAILABLE",
            "health_check_listener"    => nil,
            "instances_security_group" => "acb2ae30ebdd443a845e18cff0514917",
            "hourly_cost"              => "0.00",
            "health_check_interval"    => 30,
            "monthly_cost"             => "0.00",
            "instances_out_of_service" => nil,
            "instances_in_service"     => nil,
            "health_check_timeout"     => 5,
            "metadata"                 => {},
            "provider_load_balancer"   => {
              "dns_name" => "",
              "state"    => "IGNORE",
              "why"      => ""
            }
          }
          self.data[:load_balancers][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
