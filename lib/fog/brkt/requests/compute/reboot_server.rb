module Fog
  module Compute
    class Brkt
      class Real
        def reboot_server(id)
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/instance/#{id}/reboot"
          )
        end
      end

      class Mock
        def reboot_server(id)
          Excon::Response.new(:body => { "request_id" => "12345" })
        end
      end
    end
  end
end
