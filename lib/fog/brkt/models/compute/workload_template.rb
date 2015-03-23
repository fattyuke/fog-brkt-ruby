require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class WorkloadTemplate < Fog::Model
        module State
          PUBLISHED = "PUBLISHED"
          DRAFT = "DRAFT"
          SAVED = "SAVED"
        end

        identity :id

        attribute :name
        attribute :description
        attribute :assigned_groups
        attribute :assigned_zones
        attribute :fixed_charge, :type => :float
        attribute :base_hourly_rate, :type => :float
        attribute :hourly_cost, :type => :float
        attribute :daily_cost, :type => :float
        attribute :monthly_cost, :type => :float
        attribute :max_cost, :type => :float
        attribute :enable_service_domain, :type => :boolean
        attribute :state
        attribute :metadata

        def save
          if persisted?
            data = service.update_workload_template(attributes).body
          else
            requires :name, :assigned_groups, :assigned_zones

            if assigned_groups.empty?
              raise ArgumentError.new("assigned_groups cannot be empty")
            end
            if assigned_zones.empty?
              raise ArgumentError.new("assigned_zones cannot be empty")
            end

            data = service.create_workload_template(attributes).body
          end

          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          service.delete_workload_template(id)
          true
        end

        def published?
          state == State::PUBLISHED
        end

        def saved?
          state == State::SAVED
        end

        def draft?
          state == State::DRAFT
        end

        def enable_service_domain?
          !!enable_service_domain
        end

        def publish!
          requires :id

          if state == State::PUBLISHED
            raise ArgumentError.new("workload template is already published")
          end

          self.state = State::PUBLISHED
          save
        end
      end
    end
  end
end
