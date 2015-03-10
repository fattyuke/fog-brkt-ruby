require "fog/core/collection"
require "fog/brkt/models/compute/billing_group"

module Fog
  module Compute
    class Brkt
      class BillingGroups < Fog::Collection
        model Fog::Compute::Brkt::BillingGroup

        def all
          load(service.list_billing_groups.body)
        end

        def get(id)
          new(service.get_billing_group(id))
        end
      end
    end
  end
end
