module Fog
  module Compute
    class Brkt
      class Real
        def create_workload_template(attributes={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/workloadtemplate",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_workload_template(attributes={})
          attributes = Fog::StringifyKeys.stringify(attributes)
          id = Fog::Brkt::Mock.id
          data = {
            "id"                    => id,
            "name"                  => attributes["name"],
            "description"           => "",
            "assigned_groups"       => attributes["assigned_groups"],
            "assigned_zones"        => attributes["assigned_zones"],
            "fixed_charge"          => "0.00",
            "base_hourly_rate"      => "0.00000",
            "hourly_cost"           => "0.00",
            "daily_cost"            => "0.00",
            "monthly_cost"          => "0.00",
            "max_cost"              => nil,
            "enable_service_domain" => false,
            "workloads"             => "/v1/api/config/workloadtemplate/#{id}/workloads",
            "instance_templates"    => "/v1/api/config/workloadtemplate/#{id}/instancetemplates",
            "created_time"          => "2015-03-23T17:12:30.941609+00:00",
            "created_by"            => "user@example.com",
            "modified_time"         => "2015-03-23T17:12:30.941638+00:00",
            "modified_by"           => "user@example.com",
            "customer"              => customer.id,
            "errors"                => {},
            "state"                 => "PUBLISHED",
            "last_deployed_time"    => nil,
            "metadata"              => {}
          }
          self.data[:workload_templates][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
