require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Workload < Fog::Model
        module State
          READY = "READY"
        end


        # @!group Attributes

        identity :id

        # @return [String]
        attribute :name
        # @return [String]
        attribute :description
        attribute :billing_group, :aliases => [:billing_group_id, "billing_group_id"]
        attribute :zone,          :aliases => [:zone_id, "zone_id"]
        attribute :fixed_charge, :type => :float
        attribute :base_hourly_rate, :type => :float
        attribute :hourly_cost, :type => :float
        attribute :daily_cost, :type => :float
        attribute :monthly_cost, :type => :float
        attribute :max_cost, :type => :float
        # @return [Time]
        attribute :lease_expire_time, :type => :time
        # @return [String]
        attribute :state
        attribute :service_domain
        attribute :expired
        attribute :workload_template

        # @!endgroup

        # Create or update workload.
        # Required attributes for create: {#name}, {#billing_group}, {#zone}
        #
        # @return [true]
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

        # Delete server
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_workload(id)
          true
        end

        # Get servers in the workload
        #
        # @return [Servers] servers collection
        def servers
          service.servers(:workload => self)
        end

        # Has the resource lease expired
        #
        # @return [Servers] servers collection
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
