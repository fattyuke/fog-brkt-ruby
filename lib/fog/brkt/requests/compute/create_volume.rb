module Fog
  module Compute
    class Brkt
      class Real
        def create_volume(name, computing_cell_id, billing_group_id, size_in_gb, options={})
          body = Fog::StringifyKeys.stringify(options).merge({
            "name"           => name,
            "computing_cell" => computing_cell_id,
            "billing_group"  => billing_group_id,
            "size_in_gb"     => size_in_gb
          })
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/brktvolume",
            :body    => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def create_volume(name, computing_cell_id, billing_group_id, size_in_gb, options={})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                          => id,
            "name"                        => name,
            "billing_group"               => billing_group_id,
            "computing_cell"              => computing_cell_id,
            "description"                 => "This is an example resource",
            "auto_snapshot_duration_days" => 7,
            "availability"                => 2,
            "bracket_volume_template"     => nil,
            "children"                    => "/v1/api/config/brktvolume/#{id}/children",
            "created_by"                  => "user@example.com",
            "created_time"                => "2014-05-20T19:56:58.782760+00:00",
            "customer"                    => Fog::Brkt::Mock.id,
            "daily_cost"                  => nil,
            "deleted"                     => false,
            "expired"                     => false,
            "hourly_cost"                 => nil,
            "instance"                    => options[:instance],
            "iops"                        => 5000,
            "iops_max"                    => 8000,
            "is_readonly"                 => false,
            "iscsi_target_ip"             => "10.0.45.9",
            "large_io"                    => false,
            "lease_expire_time"           => "2014-05-20T19:56:58.782760+00:00",
            "metadata"                    => { "role" => "example" },
            "min_iops"                    => 10000,
            "min_size"                    => 2000,
            "modified_by"                 => "user@example.com",
            "modified_time"               => "2014-05-20T19:56:58.782760+00:00",
            "monthly_cost"                => nil,
            "parent"                      => nil,
            "provider_bracket_volume"     => {
              "state" => "READY",
              "why"   => ""
            },
            "remaining_gb"                => 2000,
            "remaining_iops"              => 10000,
            "requested_state"             => "AVAILABLE",
            "size_in_gb"                  => size_in_gb,
            "slo"                         => 1,
            "version"                     => 2
          }
          self.data[:volumes][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
