module Fog
  module Compute
    class Brkt
      class Real
        def update_workload_template(id, attributes={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/workloadtemplate/#{id}",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def update_workload_template(id, attributes={})
          workload_data = self.data[:workload_templates][id]
          workload_data.merge!(Fog::StringifyKeys.stringify(attributes))
          Excon::Response.new(:body => workload_data)
        end
      end
    end
  end
end
