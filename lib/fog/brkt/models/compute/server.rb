require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class Server < Fog::Compute::Server
        identity :id

        attribute :name
        attribute :description
        attribute :workload_id,     :aliases => "workload"
        attribute :image_id,        :aliases => "image_definition"
        attribute :machine_type_id, :aliases => "machine_type"

        def save
          requires :name, :image_id, :machine_type_id, :workload_id

          data = service.create_server(image_id, machine_type_id, name, workload_id).body
          merge_attributes(data)
          true
        end

        def start
        end

        def stop(force=false)
        end

        def reboot
        end

        def destroy
          requires :id

          service.delete_server(id)
        end
      end
    end
  end
end
