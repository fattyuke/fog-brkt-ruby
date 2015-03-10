module Fog
  module Compute
    class Brkt
      class Real
        def get_network(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/network/#{id}"
          )
        end
      end

      class Mock
        def get_network(id)
          Excon::Response.new(:body => self.data[:networks][id])
        end
      end
    end
  end
end
