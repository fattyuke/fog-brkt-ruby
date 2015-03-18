require "fog/core/collection"
require "fog/brkt/models/compute/image"

module Fog
  module Compute
    class Brkt
      class Images < Fog::Collection
        model Fog::Compute::Brkt::Image

        attr_accessor :operating_system

        def all
          if operating_system.nil?
            data = service.list_images.body
          else
            data = service.list_os_images(operating_system.id).body
          end
          load(data)
        end

        def get(id)
          begin
            new(service.get_image(id).body)
          rescue Excon::Errors::NotFound
            nil
          end
        end

        def new(attributes={})
          if operating_system
            super({:os => operating_system.id}.merge(attributes))
          else
            super
          end
        end
      end
    end
  end
end
