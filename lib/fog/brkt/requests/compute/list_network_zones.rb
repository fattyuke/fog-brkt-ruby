module Fog
  module Compute
    class Brkt
      class Real
        def list_network_zones(filter={})
          path = if filter[:network_id].nil?
            "v1/api/config/zone"
          else
            "v1/api/config/network/#{filter[:network_id]}/zones"
          end

          request(
            :expects => [200],
            :path    => path
          )
        end
      end

      class Mock
        def list_network_zones(filter={})
          response = Excon::Response.new
          response.body = self.data[:zones].map { |id, zone_data| zone_data }
          response
        end
      end
    end
  end
end
