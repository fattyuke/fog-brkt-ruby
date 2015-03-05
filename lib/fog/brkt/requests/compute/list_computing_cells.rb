module Fog
  module Compute
    class Brkt
      class Real
        def list_computing_cells
          request(
            :expects => [200],
            :path    => "v1/api/config/computingcell"
          )
        end
      end

      class Mock
        def list_computing_cells
          response = Excon::Response.new
          response.body = self.data[:computing_cells].map do |id, computing_cell_data|
            computing_cell_data
          end
          response
        end
      end
    end
  end
end
