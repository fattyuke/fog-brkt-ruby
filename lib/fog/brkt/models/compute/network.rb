require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Network < Fog::Model
        identity :id

        attribute :cidr,       :aliases => [:cidr_block, "cidr_block"]
        attribute :name
        attribute :description
      end
    end
  end
end
