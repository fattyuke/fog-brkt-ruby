require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class NetworkZone < Fog::Model
        identity :id

        attribute :cidr_block
        attribute :name
        attribute :provider_zone
        attribute :network_id,           :aliases => "network"
        attribute :use_main_route_table,                        :type => :boolean

        def save
          requires :network_id, :name, :cidr_block
        end

        alias_method :use_main_route_table?, :use_main_route_table
      end
    end
  end
end
