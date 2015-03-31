require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Network < Fog::Model
        # @!group Attributes
        identity :id

        attribute :cidr_block,       :aliases => [:cidr, "cidr"]
        attribute :name
        attribute :description
        attribute :computing_cell
        attribute :provider_network
        attribute :requested_state
        # @!endgroup

        has_one_identity :computing_cell, :computing_cells

        # Get network zones associated network
        #
        # @return [Zones] network zones collection
        def zones
          service.zones(:network => self)
        end
      end
    end
  end
end
