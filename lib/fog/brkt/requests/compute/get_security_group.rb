module Fog
  module Compute
    class Brkt
      class Real
        def get_security_group(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/securitygroup/#{id}"
          )
        end
      end

      class Mock
        def get_security_group(id)
          Excon::Response.new(:body => self.data[:security_groups][id])
        end
      end
    end
  end
end
