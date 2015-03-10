module Fog
  module Compute
    class Brkt
      class Real
        def get_customer
          request(
            :expects => [200],
            :path    => "v1/api/config/customer"
          )
        end
      end

      class Mock
        def get_customer
          Excon::Response.new(:body => self.data[:customer])
        end
      end
    end
  end
end
