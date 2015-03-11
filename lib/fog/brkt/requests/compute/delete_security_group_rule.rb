module Fog
  module Compute
    class Brkt
      class Real
        def delete_security_group_rule(id)
          request(
            :expects => [200],
            :method  => "DELETE",
            :path    => "v1/api/config/securitygrouprule/#{id}"
          )
        end
      end

      class Mock
        def delete_security_group_rule(id)
          response = Excon::Response.new
          self.data[:security_group_rules].each do |security_group_id, security_group_rules|
            if security_group_rules.has_key?(id)
              security_group_rules.delete(id)
              return
            end
          end
          response
        end
      end
    end
  end
end
