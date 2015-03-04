require "fog/compute/models/server"

module Fog
  module Compute
    class Brkt
      class Server < Fog::Compute::Server
        attribute :name
        attribute :description
        attribute :image_id,  :aliases => 'image_definition'
        attribute :arch,      :aliases => 'cpu_arch'
        attribute :cpu_cores, :aliases => 'cpu_cores_minimum', :type => :integer
        attribute :ram,       :aliases => 'ram_minimum',       :type => :integer

        def start
        end

        def stop(force=false)
        end

        def reboot
        end

        def destroy
        end
      end
    end
  end
end
