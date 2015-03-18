module Fog
  module Compute
    class Brkt
      class Real
        def get_volume(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/brktvolume/#{id}"
          )
        end
      end

      class Mock
        def get_volume(id)
          Excon::Response.new(:body => self.data[:volumes][id])
        end
      end
    end
  end
end
