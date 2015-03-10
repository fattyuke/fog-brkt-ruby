module Fog
  module Compute
    class Brkt
      class Real
        def list_zones
          request(
            :expects => [200],
            :path    => "v1/api/config/zone"
          )
        end
      end

      class Mock
        def list_zones
          response = Excon::Response.new
          response.body = data[:zones].map { |id, zone_data| zone_data }
          response
        end
      end
    end
  end
end
