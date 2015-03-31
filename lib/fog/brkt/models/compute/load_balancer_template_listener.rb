require "fog/core/model"
require "fog/brkt/models/compute/base_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplateListener < BaseListener
        # @!group Attributes
        identity :id

        attribute :load_balancer_template
        # @!endgroup

        # Create balancer template listener.
        # Required attributes: {#load_balancer_template}, {#instance_protocol}, {#instance_port},
        # {#listener_protocol}, {#listener_port}
        #
        # @return [true]
        def save
          requires :load_balancer_template, :instance_protocol, :instance_port,
            :listener_protocol, :listener_port

          data = service.create_load_balancer_template_listener(attributes).body
          merge_attributes(data)
          true
        end

        # Delete load balancer template listener
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_load_balancer_template_listener(id)
          true
        end
      end
    end
  end
end
