require "fog/core/collection"
require "fog/brkt/models/compute/security_group_rule"

module Fog
  module Compute
    class Brkt
      class SecurityGroupRules < Fog::Collection
        model Fog::Compute::Brkt::SecurityGroupRule

        # @return [SecurityGroup]
        attr_accessor :security_group

        # Get security group rules.
        # If {#security_group} attribute is set, returns only security group rules
        # scoped by security group and returns all security group rules otherwise
        #
        # @return [Array<SecurityGroupRule>] security group rules
        def all
          if security_group.nil?
            load(service.list_security_group_rules.body)
          else
            load(service.list_security_group_security_group_rules(security_group.id).body)
          end
        end

        # Create a new instance of security group rule.
        # If {#security_group} attribute is set, sets {SecurityGroupRule#security_group} attribute
        # to a {#security_group}'s id
        #
        # @param [Hash] attributes security group rule attributes
        # @return [SecurityGroupRule] SecurityGroupRule instance
        def new(attributes={})
          if security_group
            super({:security_group => security_group}.merge(attributes))
          else
            super
          end
        end
      end
    end
  end
end
