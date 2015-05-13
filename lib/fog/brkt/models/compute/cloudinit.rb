require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Cloudinit < Fog::Model
        module Platform
          LINUX = "LINUX"
          WINDOWS = "WINDOWS"
        end
        module DeploymentType
          DEFAULT = "DEFAULT"
          CONFIGURED = "CONFIGURED"
          ADVANCED = "ADVANCED"
        end
        # @!group Attributes
        identity :id

        attribute :customer
        attribute :name
        attribute :description
        attribute :platform,        :default => Platform::LINUX
        attribute :deployment_type, :default => DeploymentType::DEFAULT
        attribute :cloud_config
        attribute :user_script
        attribute :user_data
        attribute :metadata
        # @!endgroup

        def deployment_type
          if platform == Platform::WINDOWS
            case attributes[:deployment_type]
            when "EC2_DEFAULT"
              return DeploymentType::DEFAULT
            when "EC2_CONFIGURED"
              return DeploymentType::CONFIGURED
            when "EC2_ADVANCED"
              return DeploymentType::ADVANCED
            end
          end
          return attributes[:deployment_type]
        end

        def initialize(attributes={})
          case attributes[:deployment_type]
          when "EC2_DEFAULT", "EC2_CONFIGURED", "EC2_ADVANCED"
            self.platform = Platform::WINDOWS
          else
            self.platform = Platform::LINUX
          end
          super
        end

        # Create cloud init
        # Required attributes: *name*, *platform*, *deployment_type*
        #
        #
        # @return [true]
        def save
          requires :name, :platform, :deployment_type

          data = service.create_cloudinit(attributes).body
          merge_attributes(data)
          true
        end

        # Delete cloud init
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_cloudinit(id)
          true
        end
      end
    end
  end
end
