require "fog/core/collection"
require "fog/brkt/models/compute/security_group_rule"

module Fog
  module Compute
    class Brkt
      class SecurityGroupRules < Fog::Collection
        model Fog::Compute::Brkt::SecurityGroupRule

        attr_accessor :security_group

        def all
          if security_group.nil?
            load(service.list_security_group_rules.body)
          else
            load(service.list_security_group_security_group_rules(security_group.id).body)
          end
        end

        def get(id)
          raise NotImplemenetedError
        end
      end
    end
  end
end
