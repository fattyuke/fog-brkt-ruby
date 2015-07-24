module Fog
  module Compute
    class Brkt
      class Real
        def create_cloudinit(name, deployment_type = "DEFAULT", attributes = {})
          attributes = {
            :name             => name,
            :deployment_type  => deployment_type,
          }.merge(attributes)

          request(
            :expects => [201],
            :method  => "POST",
            :path    => "v1/api/config/cloudinit/",
            :body    => Fog::JSON.encode(attributes)
          )
        end
      end

      class Mock
        def create_cloudinit(name, deployment_type = "DEFAULT", attributes = {})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            "id"              => id,
            "customer"        => customer.id,
            "name"            => name,
            "deployment_type" => deployment_type,
            "description"     => "",
            "cloud_config"    => nil,
            "user_data"       => nil,
            "metadata"        => {},
            "user_script"     => "",
            "created_by"      => "admin@brkt.com",
            "modified_by"     => "admin@brkt.com",
            "created_time"    => "2015-07-23T08:35:16.026185+00:00",
            "modified_time"   => "2015-07-23T08:35:16.026234+00:00",
          }.merge(attributes)
          self.data[:cloudinits][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
