require "fog/core/collection"
require "fog/brkt/models/compute/load_balancer"

module Fog
  module Compute
    class Brkt
      class LoadBalancers < Fog::Collection
        model Fog::Compute::Brkt::LoadBalancer

        # @return [Workload]
        attr_accessor :workload

        # Get load balancers.
        #
        # @return [Array<LoadBalancer>] load balancers
        def all
          load(service.list_load_balancers.body)
        end

        # Get load balancers.
        # If {#workload} attribute is set, returns only load balancers
        # scoped by workload and returns all load balancers otherwise
        #
        # @return [Array<LoadBalancer>] load balancers
        def all(filter={})
          if workload.nil?
            load(service.list_load_balancers(filter).body)
          else
            load(service.list_workload_servers(workload.id).body)
          end
        end

        # Get load balancer by ID
        #
        # @param [String] id load balancer id
        # @return [LoadBalancer] load balancer
        def get(id)
          new(service.get_load_balancer(id).body)
        end

        # Create a new instance of load balancer.
        # If {#workload} attribute is set, sets {LoadBalancer#workload}
        # attribute to an {#workload_template}'s id
        #
        # @param [Hash] attributes load balancer attributes
        # @return [LoadBalancer] load balancer instance
        def new(attributes={})
          instance = super
          instance.workload = workload.id unless workload.nil?
          instance
        end
      end
    end
  end
end
