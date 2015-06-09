require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class VolumeTemplate < Fog::Model
        identity :id

        attribute :instance_template
        attribute :name
        attribute :description
        attribute :parent
        attribute :assigned_groups
        attribute :size_in_gb, :type => :integer
        attribute :iops
        attribute :iops_max
        attribute :is_readonly, :type => :boolean
        attribute :auto_snapshot_duration_days, :type => :integer
        attribute :large_io, :type => :boolean
        attribute :durability, :type => :integer
        attribute :slo
        attribute :fs_label
        attribute :fs_type
        attribute :fs_mount
        attribute :attach_point
        attribute :fixed_charge, :type => :float
        attribute :base_hourly_rate, :type => :float
        attribute :hourly_cost, :type => :float
        attribute :daily_cost, :type => :float
        attribute :monthly_cost, :type => :float
        attribute :state
        attribute :metadata

        def read_only?
          !!is_readonly
        end

        def large_io?
          !!large_io
        end

        def save
          requires :instance_template, :name, :size_in_gb, :iops

          attrs = attributes.dup
          attrs.delete(:instance_template)
          data = service.create_volume_template(instance_template, attrs).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_volume_template(id)
          true
        end
      end
    end
  end
end
