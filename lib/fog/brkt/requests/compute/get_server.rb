module Fog
  module Compute
    class Brkt
      class Real
        def get_server(id)
          request(
            :expects => [200],
            :path    => "v2/api/config/instance/#{id}?show_deleted=true"
          )
        end
      end

      class Mock
        def get_server(id)
          Excon::Response.new(:body => self.data[:servers][id])
        end
      end
    end
  end
end
