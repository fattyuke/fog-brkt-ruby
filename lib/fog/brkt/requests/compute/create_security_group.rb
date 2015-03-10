module Fog
  module Compute
    class Brkt
      class Real
        def create_security_group(network_id, name, options = {})
          body = Fog::StringifyKeys.stringify(options).merge({:name => name})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/network/#{network_id}/securitygroups",
            :body    => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def create_security_group(network_id, name, options = {})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                      => id,
            "name"                    => name,
            "description"             => "",
            "customer"                => customer.id,
            "created_by"              => "user@example.com",
            "modified_by"             => "user@example.com",
            "created_time"            => "2015-03-10T18:10:54.807740+00:00",
            "modified_time"           => "2015-03-10T18:10:54.807773+00:00",
            "rules"                   => "/v1/api/config/securitygroup/#{id}/rules",
            "requested_state"         => "AVAILABLE",
            "provider_security_group" => {"state" => "IGNORE", "why" => ""},
            "metadata"                => {},
            "network"                 => self.data[:networks][network_id]
          }
          self.data[:security_groups][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
