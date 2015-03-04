require "fog/core/collection"
require "fog/brkt/models/compute/image"

module Fog
  module Compute
    class Brkt
      class Images < Fog::Collection
        model Fog::Compute::Brkt::Image
      end
    end
  end
end
