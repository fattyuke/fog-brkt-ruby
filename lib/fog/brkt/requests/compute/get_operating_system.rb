module Fog
  module Compute
    class Brkt
      class Real
        def get_operating_system(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/operatingsystem/#{id}"
          )
        end
      end

      class Mock
        def get_operating_system(id)
          Excon::Response.new(:body => self.data[:operating_systems][id])
        end
      end
    end
  end
end
