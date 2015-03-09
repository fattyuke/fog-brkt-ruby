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
        attribute :workload,           :aliases => ["workload_id", :workload_id]
        attribute :image_definition,   :aliases => ["image_id", :image_id]
        attribute :machine_type,       :aliases => ["machine_type_id", :machine_type_id]
        attribute :ram,                                                :type => :float
        attribute :cpu_cores,                                          :type => :integer
        attribute :provider_instance
        attribute :ip_address
        attribute :internet_accessible,                                :type => :boolean
        attribute :internet_ip_address

        def initialize(options={})
          self.provider_instance = {}
          super
        end

        def ready?
          provider_instance["state"] == State::READY
        end

        def internet_accessible?
          !!internet_accessible
        end

        def save
          requires :name, :image_definition, :machine_type, :workload

          data = service.create_server(image_definition, machine_type, name, workload, attributes).body
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
