module Fog
  module Compute
    class Brkt
      class Real
        def create_server(image_id, machine_type_id, name, workload_id, options = {})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v2/api/config/instance",
            :body    => Fog::JSON.encode({
              :image_definition => image_id,
              :machine_type     => machine_type_id,
              :name             => name,
              :workload         => workload_id
            })
          )
        end
      end

      class Mock
        def create_server(image_id, machine_type_id, name, workload_id, options = {})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                  => id,
            "workload"            => workload_id,
            "name"                => name,
            "description"         => "",
            "load_balancer"       => nil,
            "customer"            => Fog::Brkt::Mock.id,
            "instance_template"   => nil,
            "service_name_fqdn"   => nil,
            "service_name"        => nil,
            "cpu_cores"           => 4,
            "ram"                 => 15.0,
            "modified_time"       => "2015-03-04T22:32:02.496169+00:00",
            "internet_accessible" => false,
            "machine_type"        => machine_type_id,
            "created_time"        => "2015-03-04T22:32:02.496133+00:00",
            "internet_ip_address" => nil,
            "ip_address"          => nil,
            "security_groups"     => [],
            "billing_group"       => nil,
            "lease_expire_time"   => nil,
            "modified_by"         => "user@example.com",
            "zone"                => "df43995a1d8a48d28b835238bfd079b4",
            "provider_instance"   => {
              "state" => "IGNORE",
              "why"   => ""
            }
          }
          self.data[:servers][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
