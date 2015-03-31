require "fog/core/collection"
require "fog/brkt/models/compute/server_template"

module Fog
  module Compute
    class Brkt
      class ServerTemplates < Fog::Collection
        model Fog::Compute::Brkt::ServerTemplate

        # @return [WorkloadTemplate]
        attr_accessor :workload_template

        # Get server templates associated with {#workload_template}
        # Requires {#workload_template} attribute to be set.
        #
        # @return [Array<ServerTemplate>] server templates
        def all
          requires :workload_template
          load(service.list_workload_template_server_templates(workload_template.id).body)
        end

        # Get server template by ID
        #
        # @param [String] id server template id
        # @return [ServerTemplate] server template
        def get(id)
          new(service.get_server_template(id).body)
        end

        # Create a new instance of ServerTemplate.
        # If {#workload_template} attribute is set, sets {ServerTemplate#workload_template} attribute to
        # a {#workload_template}'s id
        #
        # @param [Hash] attributes server template attributes
        # @return [ServerTemplate] ServerTemplate instance
        def new(attributes={})
          instance = super
          instance.workload_template = workload_template.id unless workload_template.nil?
          instance
        end
      end
    end
  end
end
