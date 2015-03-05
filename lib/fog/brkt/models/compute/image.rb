require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :state
        attribute :base,      :aliases => :is_base,      :type => :boolean
        attribute :encrypted, :aliases => :is_encrypted, :type => :boolean
      end
    end
  end
end
