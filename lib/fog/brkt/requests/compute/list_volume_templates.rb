module Fog
  module Compute
    class Brkt
      class Real
        def list_volume_templates(instance_template_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/instancetemplate/#{instance_template_id}/brktvolumetemplates"
          )
        end
      end

      class Mock
        def list_volume_templates(instance_template_id)
          response = Excon::Response.new
          response.body = self.data[:volume_templates].select do |id, volume_template_data|
            volume_template_data["instance_template"] == instance_template_id
          end.map do |id, volume_template_data|
            volume_template_data
          end
          response
        end
      end
    end
  end
end
