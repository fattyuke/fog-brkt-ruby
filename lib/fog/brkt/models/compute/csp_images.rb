require "fog/core/collection"
require "fog/brkt/models/compute/csp_image"

module Fog
  module Compute
    class Brkt
      class CspImages < Fog::Collection
        model Fog::Compute::Brkt::CspImage

        attr_accessor :image

        def all
          requires :image
          load(service.list_image_csp_images(image.id).body)
        end

        def get(id)
          raise NotImplementedError
        end

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
