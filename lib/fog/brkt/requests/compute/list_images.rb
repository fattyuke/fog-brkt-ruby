module Fog
  module Compute
    class Brkt
      class Real
        def list_images
          request(
            :expects => [200],
            :path    => "v1/api/config/imagedefinition"
          )
        end
      end

      class Mock
        def list_images
          Excon::Response.new(:body => self.data[:images].map { |id, image_data| image_data })
        end
      end
    end
  end
end
