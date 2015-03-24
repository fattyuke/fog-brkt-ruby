require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class BaseListener < Fog::Model
        identity :id

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
      end
    end
  end
end
