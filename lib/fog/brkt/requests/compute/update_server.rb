module Fog
  module Compute
    class Brkt
      class Real
        def update_server(id, options={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v2/api/config/instance/#{id}",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_server(id, options={})
          response = Excon::Response.new
          server_data = self.data[:servers][id]
          server_data.merge!(Fog::StringifyKeys.stringify(options))
          response.body = server_data
          response
        end
      end
    end
  end
end
