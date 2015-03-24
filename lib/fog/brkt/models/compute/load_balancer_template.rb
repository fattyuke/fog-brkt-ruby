require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplate < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :workload_template
        attribute :security_group
        attribute :service_name
        attribute :health_check_target
        attribute :healthy_threshold, :type => :integer
        attribute :unhealthy_threshold, :type => :integer
        attribute :health_check_interval, :type => :integer
        attribute :health_check_timeout, :type => :integer
        attribute :state
        attribute :metadata

        def save
          if persisted?
            data = service.update_load_balancer_template(id, attributes).body
          else
            requires :name, :workload_template

            data = service.create_load_balancer_template(attributes).body
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_load_balancer_template(id)
          true
        end

        def listeners
          service.load_balancer_template_listeners(:load_balancer_template => self)
        end
      end
    end
  end
end
