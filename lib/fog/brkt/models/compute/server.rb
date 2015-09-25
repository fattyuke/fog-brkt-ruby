require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class Server < Fog::Compute::Server
        class InavalidStateError < StandardError; end

        module State
          READY = "READY"
          FAILED = "FAILED"
          POWERING_OFF = "POWERING_OFF"
          POWERED_OFF = "POWERED_OFF"
          TERMINATING = "TERMINATING"
          TERMINATED = "TERMINATED"
        end

        module StateRequest
          STOPPED = "STOPPED"
          AVAILABLE = "AVAILABLE"
        end

        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :workload
        attribute :requested_state
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
        attribute :metadata
        attribute :cloudinit,          :aliases => ["cloudinit_id", :cloudinit_id]
        # @!endgroup

        has_one_identity :workload, :workloads
        has_one_identity :image_definition, :images
        has_one_identity :machine_type, :machine_types
        has_one_identity :load_balancer, :load_balancers

        def initialize(options={})
          self.metadata = {}
          self.provider_instance = {}
          super
        end

        # @return [String]
        def state
          provider_instance["state"]
        end

        def ready?
          state == State::READY
        end

        def failed?
          state == State::FAILED
        end

        def powering_off?
          state == State::POWERING_OFF
        end

        def powered_off?
          state == State::POWERED_OFF
        end

        def terminating?
          state == State::TERMINATING
        end

        def terminated?
          state == State::TERMINATED
        end

        def internet_accessible?
          !!internet_accessible
        end

        # Create or update server.
        # Required attributes for create: {#name}, {#image_definition}, {#machine_type},
        # {#workload}
        #
        # @return [true]
        def save
          if persisted?
            requires :id
            data = service.update_server(id, attributes).body
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

        # Reboot server
        #
        # @return [true]
        def reboot
          requires :id

          service.reboot_server(id)
          true
        end

        # Stop server
        #
        # @return [true]
        def stop
          requires :id
          raise_invalid_state(State::READY) unless ready?

          self.requested_state = StateRequest::STOPPED
          save
        end

        # Start server
        #
        # @return [true]
        def start
          requires :id
          raise_invalid_state(State::POWERED_OFF) unless powered_off?

          self.requested_state = StateRequest::AVAILABLE
          save
        end

        # Terminate server
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_server(id)
          true
        end

        # Get volumes attached to a server
        #
        # @return [Volumes] volumes collection
        def volumes
          service.volumes(:instance => self)
        end

        # Attach volume to a server
        #
        # @param [Volume] volume
        # @return [void]
        def attach_volume(volume)
          volume.instance = identity
          volume.save
        end

        # Check if volume attached to a server
        #
        # @return [Boolean]
        def attached?(volume)
          not volumes.find { |v| v.identity == volume.identity }.nil?
        end

        private

        def raise_invalid_state(expected_state)
          raise InavalidStateError.new("expected to be in #{expected_state} state, but actually is #{state}")
        end
      end
    end
  end
end
