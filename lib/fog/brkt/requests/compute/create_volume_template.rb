module Fog
  module Compute
    class Brkt
      class Real
        def create_volume_template(instance_template_id, attributes)
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/instancetemplate/#{instance_template_id}/brktvolumetemplates",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_volume_template(instance_template_id, attributes)
          attributes = Fog::StringifyKeys.stringify(attributes)
          id = Fog::Brkt::Mock.id
          instance_template_data = self.data[:server_templates][instance_template_id]
          workload_template_data = self.data[:workload_templates][instance_template_data["workload_template"]]
          data = {
            "id"                          => id,
            "instance_template"           => instance_template_id,
            "name"                        => attributes["name"],
            "description"                 => "",
            "parent"                      => nil,
            "customer"                    => customer.id,
            "assigned_groups"             => workload_template_data["assigned_groups"],
            "size_in_gb"                  => attributes["size_in_gb"],
            "iops"                        => attributes["iops"],
            "iops_max"                    => attributes["iops_max"] || attributes["iops"],
            "is_readonly"                 => false,
            "auto_snapshot_duration_days" => 7,
            "large_io"                    => false,
            "availability"                => 2,
            "slo"                         => 1,
            "fs_label"                    => "",
            "fs_type"                     => nil,
            "fs_mount"                    => "",
            "attach_point"                => "",
            "fixed_charge"                => "0.00",
            "base_hourly_rate"            => "0.1076388888888888888888888889",
            "hourly_cost"                 => "0.11",
            "daily_cost"                  => "2.59",
            "monthly_cost"                => "77.50",
            "created_by"                  => "user@example.com",
            "created_time"                => "2015-03-23T22:18:48.974638+00:00",
            "modified_by"                 => "user@example.com",
            "modified_time"               => "2015-03-23T22:18:48.974670+00:00",
            "state"                       => "PUBLISHED",
            "errors"                      => {},
            "metadata"                    => {}
          }
          self.data[:volume_templates][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
