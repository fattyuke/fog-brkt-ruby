require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Image < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :state
        attribute :is_base,      :aliases => :base,      :type => :boolean
        attribute :is_encrypted, :aliases => :encrypted, :type => :boolean
        attribute :os
        attribute :os_settings
        # @!endgroup

        def encrypted?
          !!is_encrypted
        end

        def base?
          !!is_base
        end

        # Create Image.
        # Required attributes: *name*, *os*
        #
        # @return [true]
        def save
          requires :name, :os

          data = service.create_image(attributes).body
          merge_attributes(data)
          true
        end

        # Delete image
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_image(id)
          true
        end

        # @return [CspImages] Csp images collection
        def csp_images
          service.csp_images(:image => self)
        end
      end
    end
  end
end
