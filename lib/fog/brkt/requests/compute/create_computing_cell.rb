module Fog
  module Compute
    class Brkt
      class Real
        def create_computing_cell(name, cidr_block, provider, provider_options={}, options={})
          body = Fog::StringifyKeys.stringify(options).merge({
            "name"                    => name,
            "network"                 => { "cidr_block" => cidr_block },
            "provider"                => provider,
            "provider_computing_cell" => provider_options
          })
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/computingcell",
            :body    => Fog::JSON.encode(body)
          )
        end
      end

      class Mock
        def create_computing_cell(name, cidr_block, provider, provider_options={}, options={})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          network_id = Fog::Brkt::Mock.id
          data = {
            "id"                      => id,
            "name"                    => name,
            "description"             => "",
            "customer"                => Fog::Brkt::Mock.id,
            "created_by"              => "user@example.com",
            "modified_by"             => "user@example.com",
            "requested_state"         => "AVAILABLE",
            "created_time"            => "2015-03-05T19:45:29.042588+00:00",
            "modified_time"           => "2015-03-05T19:45:29.042623+00:00",
            "member_groups"           => ["1562d138fb3c44dfa85aeca9a673029e"],
            "gateway_ip"              => "None",
            "provider"                => provider,
            "metadata"                => {},
            "provider_computing_cell" => {
              "default_aws_avail_zone" => "us-west-2b",
              "state"                  => "IGNORE",
              "aws_region"             => "us-west-2",
              "why"                    => ""
            },
            "network" => {
              "id"               => network_id,
              "name"             => name,
              "customer"         => Fog::Brkt::Mock.id,
              "modified_by"      => "maksim.zhylinski@brkt.com",
              "description"      => "",
              "computing_cell"   => "53577723079a4220ade3081a12fb3492",
              "requested_state"  => "AVAILABLE",
              "modified_time"    => "2015-03-05T19:45:29.133199+00:00",
              "zones"            => "/v1/api/config/network/#{network_id}/zones",
              "created_by"       => "user@example.com",
              "created_time"     => "2015-03-05T19:45:29.133140+00:00",
              "cidr_block"       => cidr_block,
              "metadata"         => {},
              "provider_network" => {
                "state" => "IGNORE",
                "why"   => ""
              }
            }
          }
          self.data[:computing_cells][id] = data
          self.data[:networks][network_id] = data["network"]
          response.body = data
          response
        end
      end
    end
  end
end
