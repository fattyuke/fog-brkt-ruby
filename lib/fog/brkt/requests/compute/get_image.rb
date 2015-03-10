module Fog
  module Compute
    class Brkt
      class Real
        def get_image(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/imagedefinition/#{id}"
          )
        end
      end

      class Mock
        def get_image(id)
          Excon::Response.new(:body => self.data[:images][id])
        end
      end
    end
  end
end
