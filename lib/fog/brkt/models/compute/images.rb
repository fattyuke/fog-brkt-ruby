require "fog/core/collection"
require "fog/brkt/models/compute/image"

module Fog
  module Compute
    class Brkt
      class Images < Fog::Collection
        model Fog::Compute::Brkt::Image

        def all
          load(service.list_images.body)
        end

        def get(id)
          new(service.get_image(id).body)
        end
      end
    end
  end
end
