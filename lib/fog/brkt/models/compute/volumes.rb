require "fog/core/collection"
require "fog/brkt/models/compute/volume"

module Fog
  module Compute
    class Brkt
      class Volumes < Fog::Collection
        model Fog::Compute::Brkt::Volume
      end
    end
  end
end
