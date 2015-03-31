require "fog/core"

module Fog
  module Brkt
    extend Fog::Provider

    service(:compute, "Compute")

    class Mock
      # Generates random id
      #
      # @return [String] 16 character random hex
      def self.id
        Fog::Mock.random_hex(16)
      end

      # Generates random name
      #
      # @return [String] "fog-test-" string followed by 5 character random hex, example: fog-test-8bda6
      def self.name
        "fog-test-#{Fog::Mock.random_hex(5)}"
      end
    end
  end
end
