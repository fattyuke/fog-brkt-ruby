require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Workload < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :billing_group_id, :aliases => 'billing_group'
        attribute :zone_id,          :aliases => 'zone'
        attribute :max_cost, :type => :float

        def save
          requires :billing_group_id, :name, :zone_id

          data = service.create_workload(billing_group_id, name, zone_id).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_workload(id)
        end
      end
    end
  end
end
