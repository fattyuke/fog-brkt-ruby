module Fog
  module Compute
    class Brkt
      class Real
        def create_billing_group(name, options = {})
          request(
            :expects => [201],
            :method  => 'POST',
            :path    => 'v1/api/config/billinggroup/',
            :body    => Fog::JSON.encode({
              :customer    => customer.id,
              :name        => name,
              :description => options[:description],
              :members     => options[:members]
            })
          )
        end
      end

      class Mock
        def create_billing_group(name, options = {})
          response = Excon::Response.new
          id = Fog::Brkt::Mock.id
          data = {
            'customer'          => customer.id,
            'spent_cost'        => '0.00',
            'modified_by'       => 'admin@brkt.com',
            'name'              => name,
            'refundable_cost'   => '0.00',
            'description'       => options[:description],
            'created_by'        => 'admin@brkt.com',
            'allocated_cost'    => '0.00',
            'allocated_balance' => '0.00',
            'modified_time'     => '2015-01-26T22:30:00.242419+00:00',
            'members'           => "/v1/api/config/billinggroup/#{id}/members",
            'number_of_members' => (options[:members] || []).size,
            'created_time'      => '2015-01-26T22:30:00.225941+00:00',
            'metadata'          => {},
            'max_hourly_rate'   => nil,
            'id'                => id,
            'parent_balance'    => '10000.00'
          }
          self.data[:billing_groups][id] = data
          response.body = data
          response
        end
      end
    end
  end
end
