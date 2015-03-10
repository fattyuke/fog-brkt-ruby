require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class SecurityGroup < Fog::Model
        identity :id

        attribute :name
        attribute :network

        def save
          requires :name, :network

          data = service.create_security_group(network, name).body
          data.delete("network")
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_security_group(id)
        end
      end
    end
  end
end
