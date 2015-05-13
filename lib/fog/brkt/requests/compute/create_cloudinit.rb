module Fog
  module Compute
    class Brkt
      class Real
        def create_cloudinit(options = {})
          metadata = options[:metadata] ? options[:metadata] : {}
          request(
            :expects => [201],
            :method  => 'POST',
            :path    => "v1/api/config/cloudinit",
            :body    => Fog::JSON.encode({
              :name            => options[:name],
              :customer        => customer.id,
              :id              => options[:id],
              :description     => options[:description],
              :deployment_type => options[:deployment_type],
              :cloud_config    => options[:cloud_config],
              :user_config     => options[:user_config],
              :user_script     => options[:user_script],
              :metadata        => metadata
            })
          )
        end
      end

      class Mock
        def create_cloudinit(options = {})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            'id'                => id,
            'customer'          => Fog::Brkt::Mock.id,
            'name'              => options[:name],
            'description'       => options[:description],
            'created_by'        => 'admin@brkt.com',
            'modified_by'       => 'admin@brkt.com',
            'created_time'      => '2015-01-26T22:30:00.225941+00:00',
            'modified_time'     => '2015-01-26T22:30:00.242419+00:00',
            'metadata'          => {'role' => 'dev'},
            'deployment_type'   => 'CONFIGURED',
            'cloud_config'      => 'groups:\n  - ubuntu: [foo,bar]\n  - cloud-users',
            'user_script'       => nil,
            'user_data'         => nil
          }
          self.data[:cloudinits][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
