require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class ComputingCell < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :provider

        has_one :network, :networks

        def initialize(options={})
          self.provider = "AWS"
          self.network = Network.new
          super
        end

        def save
          requires :name, :provider, :network

          data = service.create_computing_cell(name, network.cidr, provider, {
            :aws_region => "us-west-2" # TODO: remove hardcode
          }).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_computing_cell(id)
          true
        end

        def network=(new_network)
          if network && new_network.is_a?(Hash)
            network.merge_attributes(new_network)
          else
            associations[:network] = new_network
          end
        end
      end
    end
  end
end
