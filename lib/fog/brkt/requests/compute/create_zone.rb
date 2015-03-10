module Fog
  module Compute
    class Brkt
      class Real
        def create_zone(network_id, cidr_block, name, options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/network/#{network_id}/zones",
            :body    => Fog::JSON.encode({
              :name       => name,
              :cidr_block => cidr_block
            })
          )
        end
      end

      class Mock
        def create_zone(network_id, cidr_block, name, options={})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"                   => id,
            "name"                 => name,
            "customer"             => Fog::Brkt::Mock.id,
            "use_main_route_table" => false,
            "network"              => network_id,
            "description"          => "",
            "modified_time"        => "2015-03-06T18:23:35.308287+00:00",
            "requested_state"      => "AVAILABLE",
            "created_by"           => "user@example.com",
            "provider_zone"        => {"state" => "IGNORE", "why" => "" },
            "created_time"         => "2015-03-06T18:23:35.308256+00:00",
            "modified_by"          => "user@example.com",
            "cidr_block"           => cidr_block,
            "metadata"             => {}
          }
          self.data[:zones][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
