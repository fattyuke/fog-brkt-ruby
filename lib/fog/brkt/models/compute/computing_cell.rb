require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class ComputingCell < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :provider
        attribute :gateway_ip
        attribute :provider_options, :aliases => ["provider_computing_cell", :provider_computing_cell]

        has_one :network, :networks

        def initialize(options={})
          self.provider = "AWS"
          self.provider_options = {}
          self.network = Network.new(:service => options[:service])
          super
        end

        def save
          requires :name, :provider, :network
          if provider_options.empty?
            raise ArgumentError.new("missing provider_options are required for this operation")
          end

          data = service.create_computing_cell(name, network.cidr, provider,
            provider_options, attributes).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_computing_cell(id)
          true
        end

        def zones
          network.zones
        end

        def network=(new_network)
          if network && new_network.is_a?(Hash)
            network.merge_attributes(new_network)
          else
            associations[:network] = new_network
          end
        end

        def completely_deleted?
          begin
            reload
            false
          rescue
            true
          end
        end
      end
    end
  end
end
