module Fog
  module Compute
    class Brkt
      class Real
        def update_volume(id, options={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/brktvolume/#{id}",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_volume(id, options={})
          response = Excon::Response.new
          volume_data = self.data[:volumes][id]
          volume_data.merge!(Fog::StringifyKeys.stringify(options))
          response.body = volume_data
          response
        end
      end
    end
  end
end
