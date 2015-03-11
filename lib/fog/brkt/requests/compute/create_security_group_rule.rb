module Fog
  module Compute
    class Brkt
      class Real
        def create_security_group_rule(security_group_id, options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/securitygroup/#{security_group_id}/rules",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_security_group_rule(security_group_id, options={})
          options = Fog::StringifyKeys.stringify(options)
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                 => id,
            "customer"           => customer.id,
            "is_ingress"         => options["is_ingress"] || true,
            "modified_by"        => "user@example.com",
            "ip_proto"           => options["ip_proto"],
            "cidr_ip"            => options["cidr_ip"],
            "port_range_from"    => options["port_range_from"],
            "port_range_to"      => options["port_range_to"],
            "modified_time"      => "2015-03-11T20:18:57.060084+00:00",
            "src_security_group" => nil,
            "created_by"         => "user@example.com",
            "created_time"       => "2015-03-11T20:18:57.060048+00:00",
            "security_group"     => security_group_id,
            "description"        => ""
          }
          self.data[:security_group_rules][security_group_id] = {}
          self.data[:security_group_rules][security_group_id][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
