module Fog
  module Compute
    class Brkt
      class Real
        def get_server_free_volume_attach_points(server_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/instance/#{server_id}/freebrktvolumeattachpoint"
          )
        end
      end

      class Mock
        def get_server_free_volume_attach_points(server_id)
          response = {
            "customer"                       => "ffffffffffff4fffafffffffffffff00",
            "free_brkt_volume_attach_points" => ["/dev/xvdp", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo"],
            "modified_by"                    => "admin@brkt.com",
            "description"                    => "",
            "created_time"                   => "2015-10-23T08:35:00.819177+00:00",
            "modified_time"                  => "2015-10-23T08:40:09.351525+00:00",
            "id"                             => server_id,
            "created_by"                     => "admin@brkt.com",
            "name"                           => "vm-a2075cc9-0d1a-46ac-b40c-f3f0f79bb9c3"
          }
          Excon::Response.new(:body => response)
        end
      end
    end
  end
end
