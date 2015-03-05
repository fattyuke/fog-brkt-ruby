require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class BillingGroup < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :members,                            :type => :array
        attribute :customer_id, :aliases => :customer

        def save
          requires :name, :customer_id

          data = service.create_billing_group(customer_id, name, {
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
