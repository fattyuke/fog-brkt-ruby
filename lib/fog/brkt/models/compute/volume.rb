require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Volume < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :computing_cell_id,           :aliases => :computing_cell
        attribute :billing_group_id,            :aliases => :billing_group
        attribute :size_in_gb,                                               :type => :integer
        attribute :iops,                                                     :type => :integer
        attribute :max_iops,                    :aliases => :iops_max,       :type => :integer
        attribute :large_io,                                                 :type => :boolean
        attribute :deleted,                                                  :type => :boolean
        attribute :expired,                                                  :type => :boolean
        attribute :auto_snapshot_duration_days,                              :type => :integer

        def save
          requires :name, :computing_cell_id, :billing_group_id

          data = service.create_volume(name, computing_cell_id, billing_group_id).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          raise NotImplementedError
        end
      end
    end
  end
end
