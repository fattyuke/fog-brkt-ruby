require "fog/core/collection"
require "fog/brkt/models/compute/volume"

module Fog
  module Compute
    class Brkt
      class Volumes < Fog::Collection
        model Fog::Compute::Brkt::Volume

        attr_accessor :instance

        def all
          if instance.nil?
            load(service.list_volumes.body)
          else
            load(service.list_instance_volumes(instance.id).body)
          end
        end

        def get(id)
          begin
            new(service.get_volume(id).body)
          rescue Excon::Errors::NotFound
            nil
          end
        end
      end
    end
  end
end
