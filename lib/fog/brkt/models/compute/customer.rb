require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Customer < Fog::Model
        # @!group Attributes
        identity :id

        attribute :name
        # @!endgroup
      end
    end
  end
end
