require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Volume < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :computing_cell,              :aliases => :computing_cell_id
        attribute :billing_group,               :aliases => :billing_group_id
        attribute :instance,                    :aliases => ["instance_id", :instance_id]
        attribute :size_in_gb,                                                  :type => :integer
        attribute :iops,                                                        :type => :integer
        attribute :max_iops,                    :aliases => :iops_max,          :type => :integer
        attribute :large_io,                                                    :type => :boolean
        attribute :deleted,                                                     :type => :boolean
        attribute :expired,                                                     :type => :boolean
        attribute :auto_snapshot_duration_days,                                 :type => :integer

        def save
          if persisted?
            requires :id
            data = service.update_volume(id, attributes).body
          else
            requires :name, :computing_cell, :billing_group
            data = service.create_volume(name, computing_cell, billing_group, attributes).body
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_volume(id)
          true
        end
      end
    end
  end
end
