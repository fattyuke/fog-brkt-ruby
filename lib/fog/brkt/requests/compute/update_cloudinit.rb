module Fog
  module Compute
    class Brkt
      class Real
        def update_cloudinit(id, attributes={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/cloudinit/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_cloudinit(id, attributes={})
          cloudinit_data = self.data[:cloudinits][id]
          cloudinit_data.merge!(Fog::StringifyKeys.stringify(attributes))
          Excon::Response.new(:body => cloudinit_data)
        end
      end
    end
  end
end
