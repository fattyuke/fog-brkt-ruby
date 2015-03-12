require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class CspImage < Fog::Model
        identity :id

        attribute :provider
        attribute :csp_image_id
        attribute :csp_settings
        attribute :state
        attribute :image_definition

        def initialize(attributes={})
          self.provider = "AWS"
          super
        end

        def save
          requires :provider, :image_definition

          data = service.create_csp_image(attributes).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_csp_image(id)
          true
        end
      end
    end
  end
end
