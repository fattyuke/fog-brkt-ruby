describe "load balancer listener requests" do
  let(:load_balancer_listener_format) do
    {
      "id"                       => String,
      "name"                     => String,
      "load_balancer"            => String,
      "instance_protocol"        => String,
      "instance_port"            => Integer,
      "listener_protocol"        => String,
      "listener_port"            => Integer,
      "customer"                 => String,
      "is_health_check_listener" => Fog::Nullable::Boolean,
      "stickiness"               => Fog::Nullable::Boolean,
      "modified_by"              => String,
      "created_by"               => String
    }
  end

  before(:all) do
    @cell = create_computing_cell
    @billing_group = compute.billing_groups.create(
      :customer_id => compute.customer.id,
      :name        => Fog::Brkt::Mock.name
    )
    @security_group = compute.security_groups.create(
      :name    => Fog::Brkt::Mock.name,
      :network => @cell.network.id
    )
    @workload = compute.workloads.create(
      :billing_group_id => @billing_group.id,
      :zone_id          => @cell.zones.first.id,
      :name             => Fog::Brkt::Mock.name
    )
    @lb = compute.load_balancers.create({
        :name           => Fog::Brkt::Mock.name,
        :workload       => @workload.id,
        :security_group => @security_group.id
    })
  end

  after(:all) do
    delete_computing_cell(@cell)
    @billing_group.destroy if @billing_group
  end

  describe "#create_load_balancer_listener" do
    before(:all) do
      @response = compute.create_load_balancer_listener({
        :load_balancer            => @lb.id,
        :instance_protocol        => "HTTP",
        :instance_port            => 80,
        :listener_protocol        => "HTTP",
        :listener_port            => 80,
        :is_health_check_listener => false
      })
    end

    after(:all) { compute.delete_load_balancer_listener(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(load_balancer_listener_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["load_balancer"]).to eq @lb.id }
      it { expect(subject["instance_protocol"]).to eq "HTTP" }
      it { expect(subject["instance_port"]).to eq 80 }
      it { expect(subject["listener_protocol"]).to eq "HTTP" }
      it { expect(subject["listener_port"]).to eq 80 }
    end
  end

  describe "#list_load_balancer_listeners" do
    before(:all) do
      @lb.listeners.create({
        :instance_protocol        => "HTTP",
        :instance_port            => 80,
        :listener_protocol        => "HTTP",
        :listener_port            => 80,
        :is_health_check_listener => false
      })
    end

    describe "response" do
      subject { compute.list_load_balancer_listeners(@lb.id).body }

      it { is_expected.to have_format([load_balancer_listener_format]) }
      it { expect(subject.size).to eq 1 }
    end
  end
end
