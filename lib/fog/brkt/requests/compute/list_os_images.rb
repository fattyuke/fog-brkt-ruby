module Fog
  module Compute
    class Brkt
      class Real
        def list_os_images(os_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/operatingsystem/#{os_id}/imagedefinitions"
          )
        end
      end

      class Mock
        def list_os_images(os_id)
          images = self.data[:images].select do |id, image_data|
            image_data["os"]["id"] == os_id
          end.map do |id, image_data|
            image_data
          end
          Excon::Response.new(:body => images)
        end
      end
    end
  end
end
