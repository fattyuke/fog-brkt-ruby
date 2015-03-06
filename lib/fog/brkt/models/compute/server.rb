require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class Server < Fog::Compute::Server
        module State
          READY = "READY"
        end

        identity :id

        attribute :name
        attribute :description
        attribute :workload_id,     :aliases => "workload"
        attribute :image_id,        :aliases => "image_definition"
        attribute :machine_type_id, :aliases => "machine_type"
        attribute :provider_instance

        def ready?
          provider_instance["state"] == State::READY
        end

        def save
          requires :name, :image_id, :machine_type_id, :workload_id

          data = service.create_server(image_id, machine_type_id, name, workload_id).body
          merge_attributes(data)
          true
        end

        def reboot
          requires :id

          service.reboot_server(id)
          true
        end

        def destroy
          requires :id

          service.delete_server(id)
          true
        end
      end
    end
  end
end
