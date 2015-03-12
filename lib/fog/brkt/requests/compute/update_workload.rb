module Fog
  module Compute
    class Brkt
      class Real
        def update_workload(id, attributes={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v2/api/config/workload/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_workload(id, attributes={})
          workload_data = self.data[:workloads][id]
          workload_data.merge!(Fog::StringifyKeys.stringify(attributes))
          Excon::Response.new(:body => workload_data)
        end
      end
    end
  end
end
