require "fog/core/collection"
require "fog/brkt/models/compute/billing_group"

module Fog
  module Compute
    class Brkt
      class BillingGroups < Fog::Collection
        model Fog::Compute::Brkt::BillingGroup

        # Get billing groups
        #
        # @return [Array<BillingGroup>] billing groups
        def all
          load(service.list_billing_groups.body)
        end

        # Get billing group by ID
        #
        # @param [String] id Billing group id
        # @return [BillingGroup] billing group
        def get(id)
          new(service.get_billing_group(id).body)
        end
      end
    end
  end
end
