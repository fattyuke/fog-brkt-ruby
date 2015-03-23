module Fog
  module Compute
    class Brkt
      class Real
        def delete_server_template(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/instancetemplate/#{id}"
          )
        end
      end

      class Mock
        def delete_server_template(id)
          self.data[:server_templates].delete(id)
          Excon::Response.new
        end
      end
    end
  end
end
