module Fog
  module Compute
    class Brkt
      class Real
        def delete_billing_group(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/billinggroup/#{id}"
          )
        end
      end

      class Mock
        def delete_billing_group(id)
          response = Excon::Response.new
          self.data[:billing_groups].delete(id)
          response
        end
      end
    end
  end
end
