module Fog
  module Compute
    class Brkt
      class Real
        def list_security_group_security_group_rules(security_group_id)
          request(
            :expects => [200],
            :path    => "v1/api/config/securitygroup/#{security_group_id}/rules"
          )
        end
      end

      class Mock
        def list_security_group_security_group_rules(security_group_id)
          response = Excon::Response.new
          data = self.data[:security_group_rules].select do |id, security_group_rules|
            security_group_id == id
          end.map do |id, security_group_rules|
            security_group_rules.map do |security_group_rule_id, security_group_rule_data|
              security_group_rule_data
            end
          end.flatten
          response.body = data
          response
        end
      end
    end
  end
end
