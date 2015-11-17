require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class Server < Fog::Compute::Server
        class InvalidStateError < StandardError; end

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
        attribute :security_groups
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

        attr_writer :ssh_ip_address, :ssh_username, :ssh_port
        attr_reader :private_key_path

        def private_key_path=(private_key_path)
          @private_key_path = File.expand_path(private_key_path)
          @private_key = File.read(@private_key_path)
        end

        # Get private SSH key for ssh/scp used interactions with server
        #
        # @return [String] private SSH key
        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def private_key=(value)
          @private_key = value
        end

        # Get TCP port used for ssh/scp interactions with server
        #
        # @return [Fixnum] port
        # @note By default this returns 22
        def ssh_port
          @ssh_port ||= 22
        end

        # Get IP Address used for ssh/scp interactions with server
        #
        # @return [String] IP Address
        # @note By default this returns the ip_address
        def ssh_ip_address
          @ssh_ip_address || ip_address
        end

        # Upload file to server using SCP
        #
        # @param local_path [String] local file path
        # @param remote_path [String] remote_path remote file path
        # @param upload_options [Hash] upload options (optional)
        def upload(local_path, remote_path, upload_options = {})
          requires :ssh_ip_address, :ssh_username

          Fog::SCP.new(ssh_ip_address, ssh_username, ssh_options).upload(local_path, remote_path, upload_options)
        end

        # Download file from server using SCP
        #
        # @param remote_path [String] remote file path
        # @param local_path [String] local file path
        # @param download_options [Hash] upload options (optional)
        def download(remote_path, local_path, download_options = {})
          requires :ssh_ip_address, :ssh_username

          Fog::SCP.new(ssh_ip_address, ssh_username, ssh_options).download(remote_path, local_path, download_options)
        end

        # Run commands on server with SSH
        #
        # @param commands [String, Array] single command or array of commands to execute (optional)
        # @param options [Hash] SSH options
        def ssh(commands, options = {}, &blk)
          requires :ssh_ip_address, :ssh_username

          options = ssh_options.merge(options)

          Fog::SSH.new(ssh_ip_address, ssh_username, options).run(commands, &blk)
        end

        # Check if server SSHable
        #
        # @param options [Hash] SSH options (optional)
        # @return [Boolean]
        def sshable?(options = {})
          ready? && !ssh_ip_address.nil? && !!Timeout.timeout(8) { ssh("pwd", options) }
        rescue SystemCallError, Net::SSH::AuthenticationFailed, Net::SSH::Disconnect, Timeout::Error
          false
        end

        # Returns available volume attach points
        #
        # @return [Array]
        def free_volume_attach_points
          requires :id
          service.get_server_free_volume_attach_points(id).body['free_brkt_volume_attach_points']
        end

        private

        def ssh_options
          @ssh_options ||= {}
          ssh_options = @ssh_options.merge(:port => ssh_port)
          if private_key
            ssh_options[:key_data] = [private_key]
            ssh_options[:auth_methods] = %w(publickey)
          end
          ssh_options
        end

        def raise_invalid_state(expected_state)
          raise InvalidStateError.new("expected to be in #{expected_state} state, but actually is #{state}")
        end
      end
    end
  end
end
