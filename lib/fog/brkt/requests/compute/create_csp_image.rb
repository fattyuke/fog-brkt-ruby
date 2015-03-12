module Fog
  module Compute
    class Brkt
      class Real
        def create_csp_image(options={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/cspimage",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_csp_image(options={})
          options = Fog::StringifyKeys.stringify(options)
          id = Fog::Brkt::Mock.id
          image_id = options["image_definition"]
          data = {
            "id"               => id,
            "customer"         => customer.id,
            "provider"         => options["provider"],
            "csp_image_id"     => nil,
            "modified_by"      => "user@example.com",
            "modified_time"    => "2015-03-12T20:48:02.737177+00:00",
            "state"            => "IGNORE",
            "created_by"       => "user@example.com",
            "created_time"     => "2015-03-12T20:48:02.737130+00:00",
            "csp_settings"     => {},
            "image_definition" => self.data[:images][image_id]
          }
          self.data[:csp_images][id] = data
          Excon::Response.new(:body => data)
        end
      end
    end
  end
end
