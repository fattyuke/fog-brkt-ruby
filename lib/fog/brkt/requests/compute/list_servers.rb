module Fog
  module Compute
    class Brkt
      class Real
        def list_servers(filter={})
          request(
            :expects => [200],
            :path    => "v2/api/config/instance",
            :query   => filter
          )
        end
      end

      class Mock
        def list_servers(filter={})
          response = Excon::Response.new
          response.body = self.data[:servers].map { |id, server_data| server_data }
          response
        end
      end
    end
  end
end
