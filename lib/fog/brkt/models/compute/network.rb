require "fog/core/model"
require "fog/core/association"

module Fog
  module Compute
    class Brkt
      class Network < Fog::Model
        identity :id

        attribute :cidr,       :aliases => [:cidr_block, "cidr_block"]
        attribute :name
        attribute :description

        def zones
          @zones ||= begin
            Fog::Compute::Brkt::NetworkZones.new({
              :service => service,
              :network => self
            })
          end
        end
      end
    end
  end
end
