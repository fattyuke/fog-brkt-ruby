require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class ServerTemplate < Fog::Compute::Server
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
        attribute :cloudinit_id
        attribute :cloudinit_script
        attribute :cloudinit_type
        attribute :internet_accessible, :type => :boolean
        attribute :state
        attribute :metadata

        def save
          if persisted?
            data = service.update_server_template(id, attributes).body
          else
            requires :workload_template, :name, :image_definition

            attrs = attributes.dup
            attrs.delete(:workload_template)
            data = service.create_server_template(workload_template, attrs).body
          end

          merge_attributes(data)
          true
        end

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

        def internet_accessible?
          !!internet_accessible
        end
      end
    end
  end
end
