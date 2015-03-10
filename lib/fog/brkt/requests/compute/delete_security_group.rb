module Fog
  module Compute
    class Brkt
      class Real
        def delete_security_group(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/securitygroup/#{id}"
          )
        end
      end

      class Mock
        def delete_security_group(id)
          response = Excon::Response.new
          self.data[:security_groups].delete(id)
          response
        end
      end
    end
  end
end
