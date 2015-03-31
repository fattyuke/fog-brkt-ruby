require "fog/core/collection"
require "fog/brkt/models/compute/security_group"

module Fog
  module Compute
    class Brkt
      class SecurityGroups < Fog::Collection
        model Fog::Compute::Brkt::SecurityGroup

        # Get security groups
        #
        # @return [Array<SecurityGroup>] security groups
        def all
          load(service.list_security_groups.body)
        end

        # Get security group by ID
        #
        # @param [String] id security group id
        # @return [SecurityGroup] security group
        def get(id)
          new(service.get_security_group(id).body)
        end

        def new(attributes={})
          attributes["network"] = attributes["network"]["id"] if attributes["network"]
          super
        end
      end
    end
  end
end
