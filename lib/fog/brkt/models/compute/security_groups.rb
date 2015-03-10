require "fog/core/collection"
require "fog/brkt/models/compute/security_group"

module Fog
  module Compute
    class Brkt
      class SecurityGroups < Fog::Collection
        model Fog::Compute::Brkt::SecurityGroup

        def all
          load(service.list_security_groups.body)
        end

        def get(id)
          raise NotImplemenetedError
        end

        def new(attributes={})
          attributes["network"] = attributes["network"]["id"] if attributes["network"]
          super
        end
      end
    end
  end
end
