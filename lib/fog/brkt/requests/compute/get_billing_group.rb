module Fog
  module Compute
    class Brkt
      class Real
        def get_billing_group(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/billinggroup/#{id}"
          )
        end
      end

      class Mock
        def get_billing_group(id)
          Excon::Response.new(:body => self.data[:billing_groups][id])
        end
      end
    end
  end
end
