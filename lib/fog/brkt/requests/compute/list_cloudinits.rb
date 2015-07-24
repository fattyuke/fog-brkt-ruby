module Fog
  module Compute
    class Brkt
      class Real
        def list_cloudinits
          request(
            :expects => [200],
            :path    => "v1/api/config/cloudinit"
          )
        end
      end

      class Mock
        def list_cloudinits
          response = Excon::Response.new
          response.body = self.data[:billing_groups].values
          response
        end
      end
    end
  end
end
