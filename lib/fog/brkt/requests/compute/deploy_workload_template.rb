module Fog
  module Compute
    class Brkt
      class Real
        def deploy_workload_template(workload_template_id, attributes)
          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/workloadtemplate/#{workload_template_id}/workloads",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def deploy_workload_template(workload_template_id, attributes)
          attributes = Fog::StringifyKeys.stringify(attributes)
          workload = create_workload(attributes["billing_group"], attributes["name"],
            attributes["zone"]).body
          self.data[:workloads][workload["id"]]["workload_template"] = workload_template_id
          Excon::Response.new(:body => self.data[:workloads][workload["id"]])
        end
      end
    end
  end
end
