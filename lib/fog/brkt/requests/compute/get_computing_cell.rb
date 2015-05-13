module Fog
  module Compute
    class Brkt
      class Real
        def get_computing_cell(id)
          request(
            :expects => [200],
            :path    => "v1/api/config/computingcell/#{id}?show_deleted=true"
          )
        end
      end

      class Mock
        def get_computing_cell(id)
          data = self.data[:computing_cells][id]
          raise Excon::Errors::NotFound.new("not found") if data.nil?
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
