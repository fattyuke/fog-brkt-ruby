module Fog
  module Compute
    class Brkt
      class Real
        def get_cloudinit(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/cloudinit/#{id}"
          )
        end
      end

      class Mock
        def get_cloudinit(id)
          Excon::Response.new(:body => self.data[:cloudinits][id])
        end
      end
    end
  end
end
