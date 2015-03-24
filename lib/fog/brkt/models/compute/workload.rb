require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Workload < Fog::Model
        module State
          READY = "READY"
        end

        identity :id

        attribute :name
        attribute :description
        attribute :billing_group, :aliases => [:billing_group_id, "billing_group_id"]
        attribute :zone,          :aliases => [:zone_id, "zone_id"]
        attribute :fixed_charge, :type => :float
        attribute :base_hourly_rate, :type => :float
        attribute :hourly_cost, :type => :float
        attribute :daily_cost, :type => :float
        attribute :monthly_cost, :type => :float
        attribute :max_cost, :type => :float
        attribute :state
        attribute :service_domain
        attribute :expired
        attribute :workload_template

        def save
          if persisted?
            data = service.update_workload(id, attributes).body
          else
            requires :billing_group, :name, :zone

            data = service.create_workload(billing_group, name, zone).body
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_workload(id)
          true
        end

        def servers
          service.servers(:workload => self)
        end

        def expired?
          !!expired
        end

        def ready?
          state == State::READY
        end
      end
    end
  end
end
