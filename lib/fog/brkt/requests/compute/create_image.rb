module Fog
  module Compute
    class Brkt
      class Real
        def create_image(options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/imagedefinition",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_image(options={})
          options = Fog::StringifyKeys.stringify(options)
          id = Fog::Brkt::Mock.id
          os_id = options["os"]
          data = {
            "id"                 => id,
            "name"               => options["name"],
            "description"        => "",
            "customer"           => customer.id,
            "os_settings"        => {},
            "is_base"            => false,
            "is_encrypted"       => false,
            "unencrypted_parent" => nil,
            "csp_images"         => "/v1/api/config/imagedefinition/#{id}/cspimages",
            "metadata"           => {},
            "state"              => "IGNORE",
            "created_by"         => "user@example.com",
            "created_time"       => "2015-03-12T19:56:25.158329+00:00",
            "modified_by"        => "user@example.com",
            "modified_time"      => "2015-03-12T19:56:25.158369+00:00",
            "os"                 => self.data[:operating_systems][os_id]
          }
          self.data[:images][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
