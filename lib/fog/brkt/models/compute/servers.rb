require "fog/core/collection"
require "fog/brkt/models/compute/server"

module Fog
  module Compute
    class Brkt
      class Servers < Fog::Collection
        model Fog::Compute::Brkt::Server

        def all(filter={})
          load(service.list_servers(filter).body)
        end
      end
    end
  end
end
