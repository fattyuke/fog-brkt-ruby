module Fog
  module Compute
    class Brkt
      class Real
        def list_security_groups
          request(
            :expects => [200],
            :path    => "v1/api/config/securitygroup"
          )
        end
      end

      class Mock
        def list_security_groups
          response = Excon::Response.new
          response.body = self.data[:security_groups].map do |id, security_group_data|
            security_group_data
          end
          response
        end
      end
    end
  end
end
