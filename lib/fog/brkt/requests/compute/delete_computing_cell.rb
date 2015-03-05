module Fog
  module Compute
    class Brkt
      class Real
        def delete_computing_cell(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/computingcell/#{id}"
          )
        end
      end

      class Mock
        def delete_computing_cell(id)
          response = Excon::Response.new
          self.data[:computing_cells].delete(id)
          response
        end
      end
    end
  end
end
