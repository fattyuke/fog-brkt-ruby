module Fog
  module Compute
    class Brkt
      class Real
        def list_networks
          request(
            :expects => [200],
            :path    => "v1/api/config/network"
          )
        end
      end

      class Mock
        def list_networks
          response = Excon::Response.new
          response.body = data[:networks].map { |id, network_data| billing_group_data }
          response
        end
      end
    end
  end
end
