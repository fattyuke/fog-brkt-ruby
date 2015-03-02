require "fog/core/collection"
require "fog/brkt/models/compute/server"

module Fog
  module Compute
    class Brkt
      class Servers < Fog::Collection
        model Fog::Compute::Brkt::Server
      end
    end
  end
end
