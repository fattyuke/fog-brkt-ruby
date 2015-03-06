module Fog
  module Compute
    class Brkt
      class Real
        def delete_network_zone(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/zone/#{id}"
          )
        end
      end

      class Mock
        def delete_network_zone(id)
          response = Excon::Response.new
          self.data[:zones].delete(id)
          response
        end
      end
    end
  end
end
