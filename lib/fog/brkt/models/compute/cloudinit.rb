module Fog
  module Compute
    class Brkt
      class Cloudinit < Fog::Model
        module Type
          DEFAULT    = 'DEFAULT'
          CONFIGURED = 'CONFIGURED'
          ADVANCED   = 'ADVANCED'
        end

        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :deployment_type, :default => Type::DEFAULT
        attribute :cloud_config
        attribute :user_data
        attribute :user_script
        attribute :metadata
        # @!endgroup

        # Create or update a cloud init.
        # Required attributes for create: {#name}, {#deployment_type}
        #
        # @return [true]
        def save
          if persisted?
            data = service.update_cloudinit(id, attributes).body
          else
            requires :name, :deployment_type

            attrs = attributes.dup
            data = service.create_cloudinit(name, deployment_type, attrs).body
          end

          merge_attributes(data)
          true
        end

        # Delete server template
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
