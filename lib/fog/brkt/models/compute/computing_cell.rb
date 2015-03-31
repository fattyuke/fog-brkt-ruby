require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class ComputingCell < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :provider
        attribute :gateway_ip
        attribute :provider_options, :aliases => ["provider_computing_cell", :provider_computing_cell]
        # @!endgroup

        has_one :network, :networks

        def initialize(arguments={})
          self.provider = "AWS"
          self.provider_options = {}
          self.network = Network.new(:service => arguments[:service])
          super
        end

        # Create computing cell.
        # Required attributes: *name*, *provider*, *network*, *provider_options*
        #
        # @return [true]
        def save
          requires :name, :provider, :network, :provider_options
          if provider_options.empty?
            raise ArgumentError.new("missing provider_options is required for this operation")
          end
          if network.cidr_block.nil? or network.cidr_block.empty?
            raise ArgumentError.new("missing network.cidr_block is required for this operation")
          end

          data = service.create_computing_cell(name, network.cidr_block, provider,
            provider_options, attributes).body
          merge_attributes(data)
          true
        end

        # Delete computing cell
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_computing_cell(id)
          true
        end

        # Get network zones associated with computing cell's network
        #
        # @return [Zones] network zones collection
        def zones
          network.zones
        end

        # Set a new network
        #
        # @param [Hash, Network] new_network a network object or attributes hash
        # @return [void]
        def network=(new_network)
          if network && new_network.is_a?(Hash)
            network.merge_attributes(new_network)
          else
            associations[:network] = new_network
          end
        end

        # Returns true if API responds with 404
        def completely_deleted?
          begin
            reload
            false
          rescue Excon::Errors::NotFound
            true
          end
        end
      end
    end
  end
end
