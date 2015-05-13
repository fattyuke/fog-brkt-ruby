module Fog
  module Compute
    class Brkt
      class Real
        def update_cloudinit(id, options={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v2/api/config/cloudinit/#{id}",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_cloudinit(id, options={})
          response = Excon::Response.new
          cloudinit = self.data[:cloudinits][id]
          cloudinit.merge!(Fog::StringifyKeys.stringify(options))
          response.body = cloudinit
          response
        end
      end
    end
  end
end
