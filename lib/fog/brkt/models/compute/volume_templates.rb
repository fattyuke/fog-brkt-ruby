require "fog/core/collection"
require "fog/brkt/models/compute/volume_template"

module Fog
  module Compute
    class Brkt
      class VolumeTemplates < Fog::Collection
        model Fog::Compute::Brkt::VolumeTemplate

        # @return [ServerTemplate]
        attr_accessor :server_template

        # Get volume templates.
        # Requires {#server_template} attribute to be set.
        #
        # @return [Array<VolumeTemplate>] volume templates
        def all
          requires :server_template

          load(service.list_volume_templates(server_template.id).body)
        end

        # Create a new instance of VolumeTemplate and set
        # {VolumeTemplate#instance_template} field to a
        # {#server_template}'s id.
        #
        # @param [Hash] attributes Volume template attributes
        # @return [VolumeTemplate] Volume template instance
        def new(attributes={})
          instance = super
          instance.instance_template = server_template.id unless server_template.nil?
          instance
        end
      end
    end
  end
end
