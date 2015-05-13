require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Workload < Fog::Model

        # @!group Attributes
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
        attribute :enable_service_domain, :type => :boolean
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

        def ready?
          state == Compute::State::READY
        end

        # Returns true if API responds with 404
        # The API is kind of broken here and doesn't actually update
        # the state... so we fake it.
        def terminated?
          begin
            reload
            false
          rescue Excon::Errors::NotFound
            true
          end
        end

        # Get servers in the workload
        #
        # @return [Servers] servers collection
        def servers
          service.servers(:workload => self)
        end

        # Get load balancers in the workload
        #
        # @return [LoadBalancer] load balancers collection
        def load_balancers
          service.load_balancers(:workload => self)
        end

        def expired?
          !!expired
        end
      end
    end
  end
end
