module Fog
  module Compute
    class Brkt
      class Real
        def get_server_template(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/instancetemplate/#{id}"
          )
        end
      end

      class Mock
        def get_server_template(id)
          Excon::Response.new(:body => self.data[:server_templates][id])
        end
      end
    end
  end
end
