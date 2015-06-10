module Fog
  module Compute
    class Brkt
      class Real
        def update_server_template(id, attributes)
          if attributes.fetch(:image_definition, {}).has_key?("id")
            attributes[:image_definition] = attributes[:image_definition]["id"]
          end
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/instancetemplate/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_server_template(id, attributes)
          server_template_data = self.data[:server_templates][id]
          server_template_data.merge!(Fog::StringifyKeys.stringify(attributes))
          Excon::Response.new(:body => server_template_data)
        end
      end
    end
  end
end
