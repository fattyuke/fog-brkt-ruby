require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class OperatingSystem < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :version
        attribute :label
        attribute :platform
        attribute :description
        attribute :os_features
        # @!endgroup

        # Get images associated with operating system
        #
        # @return [Images] images collection
        def images
          service.images(:operating_system => self)
        end
      end
    end
  end
end
