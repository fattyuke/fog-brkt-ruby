module Fog
  module Compute
    class Brkt
      class Real
        def list_instance_volumes(instance_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/instance/#{instance_id}/brktvolumes"
          )
        end
      end

      class Mock
        def list_instance_volumes(instance_id)
          response = Excon::Response.new
          response.body = data[:volumes].select do |id, volume_data|
            volume_data["instance"] == instance_id
          end.map { |id, volume_data| volume_data }
          response
        end
      end
    end
  end
end
