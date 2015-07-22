module Fog
  module Compute
    class Brkt
      class Real
        def create_server_template(workload_template_id, attributes={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/workloadtemplate/#{workload_template_id}/instancetemplates",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_server_template(workload_template_id, attributes={})
          attributes = Fog::StringifyKeys.stringify(attributes)
          id = Fog::Brkt::Mock.id
          workload_template_data = self.data[:workload_templates][workload_template_id]
          data = {
            "id"                       => id,
            "name"                     => attributes["name"],
            "description"              => "",
            "service_name"             => "",
            "workload_template"        => workload_template_id,
            "customer"                 => customer.id,
            "assigned_groups"          => workload_template_data["assigned_groups"],
            "security_groups"          => [],
            "load_balancer_template"   => nil,
            "machine_type"             => nil,
            "requires_ssd"             => false,
            "min_quantity"             => 1,
            "cpu_arch"                 => "amd64",
            "cpu_cores_minimum"        => 1,
            "ram_minimum"              => 2,
            "requires_gpu"             => false,
            "fixed_charge"             => "0.00",
            "base_hourly_rate"         => "0.12250000",
            "hourly_cost"              => "0.13",
            "daily_cost"               => "2.94",
            "monthly_cost"             => "88.20",
            "cloudinit_data"           => nil,
            "instances"                => "/v1/api/config/instancetemplate/#{id}/instances",
            "errors"                   => {},
            "created_by"               => "user@example.com",
            "created_time"             => "2015-03-23T19:13:57.963970+00:00",
            "modified_by"              => "user@example.com",
            "modified_time"            => "2015-03-23T19:13:58.065504+00:00",
            "cloudinit_id"             => Fog::Brkt::Mock.id,
            "cloudinit_script"         => "",
            "cloudinit_type"           => "DEFAULT",
            "bracket_volume_templates" => "/v1/api/config/serverblueprint/#{id}/lunblueprints",
            "cloudinit_config"         => nil,
            "internet_accessible"      => false,
            "metadata"                 => {},
            "state"                    => "PUBLISHED",
            "image_definition"         => self.data[:images][attributes["image_definition"]],
          }
          self.data[:server_templates][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
