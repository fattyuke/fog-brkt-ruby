require "fog/core/collection"
require "fog/brkt/models/compute/server"

module Fog
  module Compute
    class Brkt
      class Servers < Fog::Collection
        model Fog::Compute::Brkt::Server

        # @return [Workload]
        attr_accessor :workload

        # Get servers.
        # If {#workload} attribute is set, returns only servers
        # scoped by workload and returns all servers otherwise
        #
        # @return [Array<Server>] servers
        def all(filter={})
          if workload.nil?
            load(service.list_servers(filter).body)
          else
            load(service.list_workload_servers(workload.id).body)
          end
        end

        # Get server by ID
        #
        # @param [String] id server id
        # @return [Server,nil] server if found, nil otherwise
        def get(id)
          begin
            new(service.get_server(id).body)
          rescue Excon::Errors::NotFound
            nil
          end
        end

        # Create a new instance of Server.
        # If {#workload} attribute is set, sets {Server#workload} attribute to
        # an {#workload}'s id
        #
        # @param [Hash] attributes server attributes
        # @return [Server] Server instance
        def new(attributes={})
          instance = super
          instance.workload = workload if workload
          instance
        end
      end
    end
  end
end
