module Fog
  module Compute
    class Brkt
      class Real
        def list_operating_systems
          request(
            :expects => [200],
            :path    => "v1/api/config/operatingsystem"
          )
        end
      end

      class Mock
        def list_operating_systems
          response = Excon::Response.new
          response.body = self.data[:operating_systems].map { |id, os_data| os_data }
          response
        end
      end
    end
  end
end
