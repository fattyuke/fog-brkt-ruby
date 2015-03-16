module Fog
  module Compute
    class Brkt
      class Real
        def create_volume_snapshot(volume_id, arguments={})
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/brktvolume/#{volume_id}/snapshot",
            :body    => Fog::JSON.encode(arguments)
          )
        end
      end

      class Mock
        def create_volume_snapshot(volume_id, arguments={})
          volume = data[:volumes][volume_id]
          id = Fog::Brkt::Mock.id
          snapshot = volume.merge(arguments)
          snapshot["id"] = id
          snapshot["parent"] = volume_id
          data[:volumes][id] = snapshot
          Excon::Response.new(:body => snapshot)
        end
      end
    end
  end
end
