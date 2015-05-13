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
          Excon::Response.new(:body => self.data[:cloudinits].map { |id, cloudinit| cloudinit })
        end
      end
    end
  end
end
