require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Customer < Fog::Model
        identity :id

        attribute :name
      end
    end
  end
end
