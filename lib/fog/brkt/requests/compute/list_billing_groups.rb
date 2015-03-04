module Fog
  module Compute
    class Brkt
      class Real
        def list_billing_groups
          request(
            :expects => [200],
            :path    => "v1/api/config/billinggroup"
          )
        end
      end

      class Mock
        def list_billing_groups
          response = Excon::Response.new
          response.body = self.data[:billing_groups].map do |id, billing_group_data|
            billing_group_data
          end
          response
        end
      end
    end
  end
end
