require "fog/core"

module Fog
  module Brkt
    extend Fog::Provider

    service(:compute, "Compute")

    class Mock
      def self.id
        Fog::Mock.random_hex(16)
      end

      def self.name
        "fog-test-#{Fog::Mock.random_hex(5)}"
      end
    end
  end
end
