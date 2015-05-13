require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class ServerTemplate < Fog::Compute::Server
        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :service_name
        attribute :workload_template
        attribute :image_definition
        attribute :machine_type
        attribute :assigned_groups
        attribute :security_groups
        attribute :load_balancer_template
        attribute :requires_ssd, :type => :boolean
        attribute :requires_encryption, :type => :boolean
        attribute :min_quantity, :type => :integer
        attribute :cpu_arch
        attribute :cpu_cores_minimum, :type => :integer
        attribute :ram_minimum, :type => :integer
        attribute :requires_gpu, :type => :boolean
        attribute :fixed_charge, :type => :float
        attribute :base_hourly_rate, :type => :float
        attribute :hourly_cost, :type => :float
        attribute :daily_cost, :type => :float
        attribute :monthly_cost, :type => :float
        attribute :cloudinit_id, :aliases => ["cloudinit", :cloudinit]
        attribute :state
        attribute :metadata
        # @!endgroup

        has_one_identity :workload_template, :workload_templates
        has_one_identity :load_balancer_template, :load_balancer_templates
        has_one_identity :machine_type, :machine_types
        has_one_identity :cloudinit_id, :cloudinits

        # Create or update server template.
        # Required attributes for create: {#name}, {#image_definition}, {#workload_template}
        #
        # @return [true]
        def save
          if persisted?
            data = service.update_server_template(id, attributes).body
          else
            requires :workload_template, :name, :image_definition

            attrs = attributes.dup
            attrs.delete(:workload_template)
            attrs[:machine_type] = associations[:machine_type]
            attrs[:load_balancer_template] = associations[:load_balancer_template]
            attrs[:cloudinit_id] = associations[:cloudinit_id]
            data = service.create_server_template(
              associations[:workload_template],
              attrs).body
          end

          merge_attributes(data)
          true
        end

        # Delete server template
        #
        # @return [true]
        def destroy
          requires :id
          service.delete_server_template(id)
          true
        end

        def requires_ssd?
          !!requires_ssd
        end

        def requires_gpu?
          !!requires_gpu
        end

        # Get volume templates attached to a server template
        #
        # @return [VolumeTemplates] volume templates collection
        def volume_templates
          service.volume_templates(:server_template => self)
        end
      end
    end
  end
end
