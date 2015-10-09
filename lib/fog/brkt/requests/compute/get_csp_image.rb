module Fog
  module Compute
    class Brkt
      class Real
        def get_csp_image(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/cspimage/#{id}"
          )
        end
      end

      class Mock
        def get_csp_image(id)
          Excon::Response.new(:body => self.data[:csp_images][id])
        end
      end
    end
  end
end
