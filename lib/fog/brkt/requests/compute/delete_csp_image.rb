module Fog
  module Compute
    class Brkt
      class Real
        def delete_csp_image(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/cspimage/#{id}"
          )
        end
      end

      class Mock
        def delete_csp_image(id)
          self.data[:csp_images].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
