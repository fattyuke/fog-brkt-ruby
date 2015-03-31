require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class SecurityGroup < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :network
        # @!endgroup

        # Create security group.
        # Required attributes on create: {#name}, {#network}
        #
        # @return [true]
        def save
          requires :name, :network

          data = service.create_security_group(network, name).body.dup
          data.delete("network")
          merge_attributes(data)
          true
        end

        # Delete security group
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_security_group(id)
        end

        # Get security group rules for security group
        #
        # @return [SecurityGroupRules] security group rules collection
        def rules
          service.security_group_rules(:security_group => self)
        end
      end
    end
  end
end
