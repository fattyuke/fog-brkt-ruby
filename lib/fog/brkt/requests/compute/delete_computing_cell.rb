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
          computing_cell = self.data[:computing_cells][id]
          computing_cell["provider_computing_cell"]["state"] = "TERMINATED"
          response
        end
      end
    end
  end
end
