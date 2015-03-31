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

        # @!group Attributes
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
        # @!endgroup

        # Create or update workload template.
        # Required attributes for create: {#name}, {#assigned_groups}, {#assigned_zones}
        #   assigned_groups – non-tmpty array of {BillingGroup} ids
        #   assigned_zones – non-tmpty array of {Zone} ids
        #
        # @return [true]
        def save
          if persisted?
            data = service.update_workload_template(id, attributes).body
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

        # Delete workload template
        #
        # @return [true]
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

        # Get server templates in the workload template
        #
        # @return [ServerTemplates] server templates collection
        def server_templates
          service.server_templates(:workload_template => self)
        end

        # Get load balancer templates in the workload template
        #
        # @return [LoadBalancerTemplates] load balancer templates collection
        def load_balancer_templates
          service.load_balancer_templates(:workload_template => self)
        end

        # Deploy the workload template
        #
        # @param [BillingGroup] billing_group billing group to deploy to
        # @param [Hash] attributes workload's attributes to override
        # @option attributes [String] :name deployed workload name. Default: {#name}
        # @option attributes [String] :zone network zone to deploy to. Default: first of {#assigned_zones}
        # @return [Workload] created workload
        def deploy(billing_group, attributes={})
          raise ArgumentError, "attributes must be hash" unless attributes.is_a?(Hash)
          attributes["name"] ||= name
          attributes["billing_group"] = billing_group.id
          attributes["zone"] = assigned_zones.first # Fix?

          workload_data = service.deploy_workload_template(self.id, attributes).body
          service.workloads.new(workload_data)
        end
      end
    end
  end
end
