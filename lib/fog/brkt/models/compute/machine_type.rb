require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class MachineType < Fog::Model
        # @!group Attributes
        identity :id

        attribute :cpu_cores,            :type => :integer
        attribute :ram,                  :type => :float
        attribute :storage_gb,           :type => :integer
        attribute :encrypted_storage_gb, :type => :float
        attribute :hourly_cost,          :type => :float
        attribute :provider,             :type => :integer
        attribute :supports_pv,          :type => :boolean
        # @!endgroup
      end
    end
  end
end
