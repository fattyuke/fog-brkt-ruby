module Fog
  module Compute
    class Brkt
      class Real
        def delete_volume_template(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/brktvolumetemplate/#{id}"
          )
        end
      end

      class Mock
        def delete_volume_template(id)
          response = Excon::Response.new
          self.data[:volume_templates].delete(id)
          response
        end
      end
    end
  end
end
