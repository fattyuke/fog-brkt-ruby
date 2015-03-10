require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :state
        attribute :is_base,      :aliases => :base,      :type => :boolean
        attribute :is_encrypted, :aliases => :encrypted, :type => :boolean

        def encrypted?
          !!is_encrypted
        end

        def base?
          !!is_base
        end
      end
    end
  end
end
