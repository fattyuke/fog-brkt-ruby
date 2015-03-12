require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class OperatingSystem < Fog::Model
        identity :id

        attribute :name
        attribute :version
        attribute :label
        attribute :platform
        attribute :description
        attribute :os_features
      end
    end
  end
end
