require "fog/core/collection"
require "fog/brkt/models/compute/cloudinit"

module Fog
  module Compute
    class Brkt
      class Cloudinits < Fog::Collection
        model Fog::Compute::Brkt::Cloudinit

        # Get cloud inits
        #
        # @return [Array<CloudInit>] cloud inits
        def all
          load(service.list_cloudinits.body)
        end

        # Get cloud init by ID
        #
        # @param [String] id cloud init id
        # @return [CloudInit] cloud init
        def get(id)
          new(service.get_cloudinit(id).body)
        end
      end
    end
  end
end
