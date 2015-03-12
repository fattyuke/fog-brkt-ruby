require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class LoadBalancer < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :workload
        attribute :billing_group
        attribute :security_group
        # attribute :cost
        # attribute :hourly_cost
        # attribute :daily_cost
        # attribute :monthly_cost
        # attribute :fixed_charge
        # attribute :base_hourly_rate
        attribute :service_name_fqdn
        attribute :service_name
        attribute :health_check_target
        attribute :healthy_threshold, :type => :integer
        attribute :unhealthy_threshold, :type => :integer
        attribute :health_check_interval, :type => :integer
        attribute :health_check_timeout, :type => :integer
        attribute :provider_load_balancer

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

        def destroy
          requires :id

          service.delete_load_balancer(id)
          true
        end
      end
    end
  end
end
