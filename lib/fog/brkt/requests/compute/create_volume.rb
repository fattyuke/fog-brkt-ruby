module Fog
  module Compute
    class Brkt
      class Real
        def create_volume(options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/brktvolume",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_volume(options={})
          options = Fog::StringifyKeys.stringify(options)
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                          => id,
            "name"                        => options["name"],
            "description"                 => "",
            "customer"                    => customer.id,
            "provider_bracket_volume"     => {"state" => "IGNORE", "why" => ""},
            "expired"                     => false,
            "deleted"                     => false,
            "daily_cost"                  => "8.44",
            "cost"                        => "0.00",
            "parent"                      => nil,
            "lease_expire_time"           => nil,
            "modified_time"               => "2015-03-10T21:51:01.356206+00:00",
            "large_io"                    => false,
            "min_iops"                    => 100,
            "iops"                        => options["iops"],
            "iops_max"                    => options["iops_max"],
            "hourly_cost"                 => "0.36",
            "fixed_charge"                => "0.00",
            "created_time"                => "2015-03-10T21:51:00.904066+00:00",
            "modified_by"                 => "user@example.com",
            "base_hourly_rate"            => "0.35156250",
            "iscsi_target_ip"             => nil,
            "children"                    => "/v1/api/config/brktvolume/#{id}/children",
            "billing_group"               => options["billing_group"],
            "min_size"                    => 10,
            "size_in_gb"                  => 10,
            "remaining_gb"                => 10240,
            "is_readonly"                 => false,
            "monthly_cost"                => "253.13",
            "auto_snapshot_duration_days" => 7,
            "remaining_iops"              => 0,
            "slo"                         => 1,
            "requested_state"             => "AVAILABLE",
            "created_by"                  => "user@example.com",
            "availability"                => 1,
            "instance"                    => nil,
            "version"                     => 2,
            "computing_cell"              => options["computing_cell"],
            "bracket_volume_template"     => nil,
            "metadata"                    => {}
          }
          self.data[:volumes][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
