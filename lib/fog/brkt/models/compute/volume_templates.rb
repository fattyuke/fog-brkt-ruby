require "fog/core/collection"
require "fog/brkt/models/compute/volume_template"

module Fog
  module Compute
    class Brkt
      class VolumeTemplates < Fog::Collection
        model Fog::Compute::Brkt::VolumeTemplate

        attr_accessor :server_template

        def all
          requires :server_template

          load(service.list_volume_templates(server_template.id).body)
        end

        def get(id)
          raise NotImplementedError
        end

        def new(attributes={})
          instance = super
          instance.instance_template = server_template.id unless server_template.nil?
          instance
        end
      end
    end
  end
end
