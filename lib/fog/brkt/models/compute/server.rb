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
        attribute :workload
        attribute :image_definition,   :aliases => ["image_id", :image_id]
        attribute :machine_type,       :aliases => ["machine_type_id", :machine_type_id]
        attribute :ram,                                                :type => :float
        attribute :cpu_cores,                                          :type => :integer
        attribute :provider_instance
        attribute :ip_address
        attribute :internet_accessible,                                :type => :boolean
        attribute :internet_ip_address
        attribute :load_balancer
        attribute :service_name
        attribute :service_name_fqdn

        has_one_identity :workload, :workloads
        has_one_identity :image_definition, :images
        has_one_identity :machine_type, :machine_types
        has_one_identity :load_balancer, :load_balancers

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
          if persisted?
            data = service.update_server(attributes).body
          else
            requires :name, :image_definition, :machine_type, :workload

            data = service.create_server(
              associations[:image_definition],
              associations[:machine_type],
              name,
              associations[:workload],
              attributes
            ).body
          end
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

        def volumes
          service.volumes(:instance => self)
        end

        def attach_volume(volume)
          volume.instance = identity
          volume.save
        end

        def attached?(volume)
          not volumes.find { |v| v.identity == volume.identity }.nil?
        end
      end
    end
  end
end
