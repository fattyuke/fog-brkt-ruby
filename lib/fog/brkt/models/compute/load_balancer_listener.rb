require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class LoadBalancerListener < Fog::Model
        identity :id

        attribute :load_balancer
        attribute :instance_protocol
        attribute :instance_port, :type => :integer
        attribute :listener_protocol
        attribute :listener_port, :type => :integer
        attribute :stickiness, :type => :boolean
        attribute :is_health_check_listener, :type => :boolean

        def stickiness?
          stickiness
        end

        def health_check?
          is_health_check_listener
        end

        def save
          requires :load_balancer, :instance_protocol, :instance_port, :listener_protocol,
            :listener_port

          data = service.create_load_balancer_listener(attributes).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_load_balancer_listener(id)
          true
        end
      end
    end
  end
end
