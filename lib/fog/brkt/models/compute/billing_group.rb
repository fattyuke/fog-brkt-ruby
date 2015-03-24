require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class BillingGroup < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :members, :type => :array
        attribute :customer, :aliases => [:customer_id]

        def save
          requires :name, :customer

          data = service.create_billing_group(customer, name, {
            :description => description,
            :members     => members
          }).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_billing_group(id)
        end
      end
    end
  end
end
