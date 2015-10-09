module Fog
  module Compute
    class Brkt
      class Real
        def update_csp_image(id, attributes={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/cspimage/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_csp_image(id, attributes={})
          response = Excon::Response.new
          csp_image_data = self.data[:csp_images][id]
          csp_image_data.merge!(Fog::StringifyKeys.stringify(attributes))
          response.body = csp_image_data
          response
        end
      end
    end
  end
end
