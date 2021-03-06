module Fog
  module Compute
    class Brkt
      class Real
        def delete_image(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/imagedefinition/#{id}"
          )
        end
      end

      class Mock
        def delete_image(id)
          response = Excon::Response.new
          self.data[:images].delete(id)
          response
        end
      end
    end
  end
end
