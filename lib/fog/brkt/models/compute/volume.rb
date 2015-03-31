require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class Volume < Fog::Model
        module State
          READY = "READY"
        end

        # @!group Attributes
        identity :id

        attribute :name
        attribute :description
        attribute :computing_cell,              :aliases => :computing_cell_id
        attribute :billing_group,               :aliases => :billing_group_id
        attribute :instance,                    :aliases => ["instance_id", :instance_id]
        attribute :size_in_gb,                                                  :type => :integer
        attribute :iops,                                                        :type => :integer
        attribute :iops_max,                                                    :type => :integer
        attribute :large_io,                                                    :type => :boolean
        attribute :deleted,                                                     :type => :boolean
        attribute :expired,                                                     :type => :boolean
        attribute :auto_snapshot_duration_days,                                 :type => :integer
        attribute :provider_bracket_volume
        # @!endgroup

        def initialize(attributes={})
          self.provider_bracket_volume = {}
          super
        end

        # Create or update volume.
        # Required attributes for create: {#name}, {#computing_cell}, {#billing_group},
        # {#size_in_gb}, {#iops}, {#iops_max}
        #
        # @return [true]
        def save
          if persisted?
            requires :id
            data = service.update_volume(id, attributes).body
          else
            requires :name, :computing_cell, :billing_group, :size_in_gb, :iops, :iops_max
            data = service.create_volume(attributes).body
          end
          merge_attributes(data)
          true
        end

        # Delete volume
        #
        # @return [true]
        def destroy
          requires :id

          service.delete_volume(id)
          true
        end

        def ready?
          provider_bracket_volume["state"] == State::READY
        end

        # Create volume snapshot
        #
        # @return [Volume] new volume instance
        def create_snapshot
          requires :id, :name, :billing_group

          snapshot_data = service.create_volume_snapshot(:id, {
            "name"          => "#{name} snapshot", # TODO: customize?
            "billing_group" => billing_group # TODO: customize?
          }).body
          collection.new(snapshot_data)
        end
      end
    end
  end
end
