module Fog
  module Compute
    class Brkt
      class Real
        def update_load_balancer(id, options={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/loadbalancer/#{id}",
            :body    => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_load_balancer(id, options={})
          options = Fog::StringifyKeys.stringify(options)
          self.data[:load_balancers][id].merge!(options)
          Excon::Response.new(:body => self.data[:load_balancers][id])
        end
      end
    end
  end
end
