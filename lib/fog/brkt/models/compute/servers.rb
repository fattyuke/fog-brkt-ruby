require "fog/core/collection"
require "fog/brkt/models/compute/server"

module Fog
  module Compute
    class Brkt
      class Servers < Fog::Collection
        model Fog::Compute::Brkt::Server

        attr_accessor :workload

        def all(filter={})
          if workload.nil?
            load(service.list_servers(filter).body)
          else
            load(service.list_workload_servers(workload.id).body)
          end
        end

        def get(id)
          new(service.get_server(id).body)
        end

        def new(attributes={})
          instance = super
          instance.workload = workload if workload
          instance
        end
      end
    end
  end
end
