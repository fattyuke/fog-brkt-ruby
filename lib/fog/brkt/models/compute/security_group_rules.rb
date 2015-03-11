require "fog/core/collection"
require "fog/brkt/models/compute/security_group_rule"

module Fog
  module Compute
    class Brkt
      class SecurityGroupRules < Fog::Collection
        model Fog::Compute::Brkt::SecurityGroupRule

        def all
          raise NotImplemenetedError
        end

        def get(id)
          raise NotImplemenetedError
        end
      end
    end
  end
end
