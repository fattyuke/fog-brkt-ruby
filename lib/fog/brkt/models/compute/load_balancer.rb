require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class LoadBalancer < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :workload
        attribute :billing_group
        attribute :security_group
        attribute :cost
        attribute :hourly_cost
        attribute :daily_cost
        attribute :monthly_cost
        attribute :fixed_charge
        attribute :base_hourly_rate
        attribute :service_name_fqdn
        attribute :service_name
        attribute :health_check_target
        attribute :healthy_threshold, :type => :integer
        attribute :unhealthy_threshold, :type => :integer
        attribute :health_check_interval, :type => :integer
        attribute :health_check_timeout, :type => :integer
        attribute :provider_load_balancer
        attribute :metadata
        # @!endgroup

        # Create or update load balancer.
        # Required attributes on create: {#name}, {#workload}, {#security_group}
        #
        # @return [true]
        def save
          if persisted?
            data = service.update_load_balancer(id, attributes).body
          else
            requires :name, :workload, :security_group

            data = service.create_load_balancer(attributes).body
          end
          merge_attributes(data)
          true
        end

        # Delete load balancer
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_load_balancer(id)
          true
        end

        # @return [String]
        def state
          provider_load_balancer["state"]
        end

        def ready?
          state == Compute::State::READY
        end

        def failed?
          state == Compute::State::FAILED
        end

        def powering_off?
          state == Compute::State::POWERING_OFF
        end

        def powered_off?
          state == Compute::State::POWERED_OFF
        end

        def terminating?
          state == Compute::State::TERMINATING
        end

        def terminated?
          state == Compute::State::TERMINATED
        end

        # Get load balancer listeners associated with load balancer
        #
        # @return [LoadBalancerListeners] load balancer listeners collection
        def listeners
          service.load_balancer_listeners(:load_balancer => self)
        end
      end
    end
  end
end
