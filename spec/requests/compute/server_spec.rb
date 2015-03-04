describe "server requests" do
  let(:server_format) do
    {
      "id"                  => String,
      "workload"            => String,
      "name"                => String,
      "description"         => String,
      "load_balancer"       => Fog::Nullable::String,
      "customer"            => String,
      "instance_template"   => Fog::Nullable::String,
      "service_name_fqdn"   => Fog::Nullable::String,
      "service_name"        => Fog::Nullable::String,
      "cpu_cores"           => Integer,
      "ram"                 => Float,
      "modified_time"       => String,
      "internet_accessible" => Fog::Boolean,
      "machine_type"        => String,
      "created_time"        => String,
      "internet_ip_address" => Fog::Nullable::String,
      "ip_address"          => Fog::Nullable::String,
      "security_groups"     => [],
      "billing_group"       => Fog::Nullable::String,
      "lease_expire_time"   => Fog::Nullable::String,
      "modified_by"         => String,
      "zone"                => String,
      "provider_instance"   => {
        "state" => String,
        "why"   => String
      }
    }
  end

  describe "#create_server" do
    before(:all) do
      @billing_group = compute.billing_groups.create(
        :customer_id => customer_id,
        :name        => Fog::Brkt::Mock.name
      )
      @workload = compute.workloads.create(
        :billing_group_id => @billing_group.id,
        :zone_id          => zone_id,
        :name             => Fog::Brkt::Mock.name
      )
      @machine_type = compute.machine_types.first
      image = compute.images.first
      @server_name = Fog::Brkt::Mock.name
      @response = compute.create_server(image.id, @machine_type.id, @server_name, @workload.id)
    end

    after(:all) do
      @workload.destroy
      @billing_group.destroy
      compute.delete_server(@response.body["id"])
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to      eq @server_name            }
      it { expect(subject["workload"]).to  eq @workload.id            }
      it { expect(subject["cpu_cores"]).to eq @machine_type.cpu_cores }
      it { expect(subject["ram"]).to       eq @machine_type.ram       }
    end
  end
end