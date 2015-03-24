require "fog/core/model"
require "fog/brkt/models/compute/base_listener"

module Fog
  module Compute
    class Brkt
      class LoadBalancerTemplateListener < BaseListener
        identity :id

        attribute :load_balancer_template

        def save
          requires :load_balancer_template, :instance_protocol, :instance_port,
            :listener_protocol, :listener_port

          data = service.create_load_balancer_template_listener(attributes).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_load_balancer_template_listener(id)
          true
        end
      end
    end
  end
end
