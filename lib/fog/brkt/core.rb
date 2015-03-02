require "fog/core"

module Fog
  module Brkt
    extend Fog::Provider

    service(:compute, "Compute")
  end
end
