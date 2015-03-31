require "fog/core/collection"
require "fog/brkt/models/compute/image"

module Fog
  module Compute
    class Brkt
      class Images < Fog::Collection
        model Fog::Compute::Brkt::Image

        # @return [OperatingSystem]
        attr_accessor :operating_system


        # Get images.
        # If {#operating_system} attribute is set, returns only images
        # scoped by operating system and returns all images otherwise
        #
        # @return [Array<Image>] images
        def all
          if operating_system.nil?
            data = service.list_images.body
          else
            data = service.list_os_images(operating_system.id).body
          end
          load(data)
        end

        # Get image by ID
        #
        # @param [String] id image id
        # @return [Image,nil] image if found, nil otherwise
        def get(id)
          begin
            new(service.get_image(id).body)
          rescue Excon::Errors::NotFound
            nil
          end
        end

        # Create a new instance of Image.
        # If {#operating_system} attribute is set, sets {Image#os} attribute to
        # an {#operating_system}'s id
        #
        # @param [Hash] attributes image attributes
        # @return [Image] Image instance
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
