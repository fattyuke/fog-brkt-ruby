require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Workload < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :billing_group, :aliases => [:billing_group_id, "billing_group_id"]
        attribute :zone,          :aliases => [:zone_id, "zone_id"]
        attribute :max_cost,                                     :type => :float
        attribute :state
        attribute :requested_state

        def save
          requires :billing_group, :name, :zone

          data = service.create_workload(billing_group, name, zone).body
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
