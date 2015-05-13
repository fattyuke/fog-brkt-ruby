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
        def delete_cloudinit(id)
          self.data[:cloudinits].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
