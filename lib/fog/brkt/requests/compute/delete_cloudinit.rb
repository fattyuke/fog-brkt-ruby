module Fog
  module Compute
    class Brkt
      class Real
        def delete_cloudinit(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/cloudinit/#{id}"
          )
        end
      end

      class Mock
        def delete_billing_group(id)
          response = Excon::Response.new
          self.data[:cloudinits].delete(id)
          response
        end
      end
    end
  end
end
