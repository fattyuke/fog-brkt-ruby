require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class CspImage < Fog::Model
        # @!group Attributes
        identity :id

        attribute :provider
        attribute :csp_image_id
        attribute :csp_settings
        attribute :state
        attribute :image_definition
        # @!endgroup

        def initialize(attributes={})
          self.provider = "AWS"
          super
        end

        # Create CSP image.
        # Required attributes: *provider*, *image_definition*
        #
        # @return [true]
        def save
          if persisted?
            requires :id

            data = service.update_csp_image(id, attributes).body
          else
            requires :provider, :image_definition

            data = service.create_csp_image(attributes).body
          end

          merge_attributes(data)
          true
        end

        # Delete CSP image
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_csp_image(id)
          true
        end
      end
    end
  end
end
