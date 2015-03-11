module Fog
  module Compute
    class Brkt
      class Real
        def delete_volume(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/brktvolume/#{id}"
          )
        end
      end

      class Mock
        def delete_volume(id)
          response = Excon::Response.new
          self.data[:volumes].delete(id)
          response
        end
      end
    end
  end
end
