module Fog
  module Compute
    class Brkt
      class Real
        def list_image_csp_images(image_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/imagedefinition/#{image_id}/cspimages"
          )
        end
      end

      class Mock
        def list_image_csp_images(image_id)
          raise NotImplementedError
        end
      end
    end
  end
end
