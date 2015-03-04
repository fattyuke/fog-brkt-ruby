module Fog
  module Compute
    class Brkt
      class Real
        def delete_server(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v2/api/config/instance/#{id}"
          )
        end
      end

      class Mock
        def delete_server(id)
          response = Excon::Response.new
          self.data[:servers].delete(id)
          response
        end
      end
    end
  end
end
