require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class BillingGroup < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :members, :type => :array
        # @!endgroup

        # Create billing group.
        # Required attributes: *name*
        #
        # @return [true]
        def save
          requires :name

          data = service.create_billing_group(name, {
            :description => description,
            :members     => members
          }).body
          merge_attributes(data)
          true
        end

        # Delete billing group
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_billing_group(id)
          true
        end
      end
    end
  end
end
