describe "server requests" do
  machine_type = compute.machine_types.first
  image        = compute.images.first

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

  before(:all) do
    @cell = create_computing_cell
    @billing_group = compute.billing_groups.create(
      :customer_id => customer_id,
      :name        => Fog::Brkt::Mock.name
    )
    @workload = compute.workloads.create(
      :billing_group_id => @billing_group.id,
      :zone_id          => @cell.zones.first.id,
      :name             => Fog::Brkt::Mock.name
    )
  end

  after(:all) do
    @workload.destroy
    @billing_group.destroy
    @cell.destroy
    # wait while computing cell will be deleted completely and API will return 404
    # to prevent hitting the limit
    Fog.wait_for { @cell.completely_deleted? }
  end

  describe "#create_server" do
    before(:all) do
      @server_name = Fog::Brkt::Mock.name
      @response = compute.create_server(image.id, machine_type.id, @server_name, @workload.id)
    end

    after(:all) { compute.delete_server(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to      eq @server_name            }
      it { expect(subject["workload"]).to  eq @workload.id            }
      it { expect(subject["cpu_cores"]).to eq machine_type.cpu_cores }
      it { expect(subject["ram"]).to       eq machine_type.ram       }
    end
  end

  describe "#list_servers" do
    before(:all) do
      @server = compute.servers.create(
        :name            => Fog::Brkt::Mock.name,
        :image_id        => image.id,
        :machine_type_id => machine_type.id,
        :workload_id     => @workload.id
      )
    end

    after(:all) { @server.destroy }

    describe "response" do
      subject { compute.list_servers.body }

      it { is_expected.to have_format([server_format]) }
    end
  end

  describe "#get_server" do
    before(:all) do
      @server = compute.servers.create(
        :name            => Fog::Brkt::Mock.name,
        :image_id        => image.id,
        :machine_type_id => machine_type.id,
        :workload_id     => @workload.id
      )
      @response = compute.get_server(@server.id)
    end

    after(:all) { @server.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_format) }
    end
  end

  describe "#update_server" do
    before(:all) do
      @server = compute.servers.create(
        :name            => Fog::Brkt::Mock.name,
        :image_id        => image.id,
        :machine_type_id => machine_type.id,
        :workload_id     => @workload.id
      )
      @response = compute.update_server(@server.id, { :name => "new name"} )
    end

    after(:all) { @server.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_format) }
      it { expect(subject["name"]).to eq "new name" }
    end
  end

  if fast_tests?
    pending "#reboot_server"
  else
    describe "#reboot_server" do
      before(:all) do
        @server = compute.servers.create(
          :name            => Fog::Brkt::Mock.name,
          :image_id        => image.id,
          :machine_type_id => machine_type.id,
          :workload_id     => @workload.id
        )
        @server.wait_for { ready? } # you cannot reboot server until it's ready
      end

      after(:all) { @server.destroy }

      describe "response" do
        subject { compute.reboot_server(@server.id).body }

        it { is_expected.to have_format({"request_id" => String }) }
      end
    end
  end
end
