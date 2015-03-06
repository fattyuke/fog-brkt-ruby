module Fog
  module Compute
    class Brkt
      class Real
        def get_computing_cell(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/computingcell/#{id}"
          )
        end
      end

      class Mock
        def get_computing_cell(id)
          Excon::Response.new(:body => self.data[:computing_cells][id])
        end
      end
    end
  end
end
