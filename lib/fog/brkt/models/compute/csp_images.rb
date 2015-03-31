require "fog/core/collection"
require "fog/brkt/models/compute/csp_image"

module Fog
  module Compute
    class Brkt
      class CspImages < Fog::Collection
        model Fog::Compute::Brkt::CspImage

        # @return [Image] image
        attr_accessor :image

        # Get CSP images.
        # Requires {#image} attribute to be set.
        #
        # @return [Array<CspImage>] CSP images
        def all
          requires :image
          load(service.list_image_csp_images(image.id).body)
        end

        # Create a new instance of CspImage and set its {CspImage#image_definition} field to collection's
        # {#image}.
        # Requires {#image} attribute to be set.
        #
        # @param [Hash] attributes CSP Image attributes
        # @return [CspImage] CSP image instance
        def new(attributes={})
          requires :image
          instance = super
          instance.image_definition = image.id
          instance
        end
      end
    end
  end
end
