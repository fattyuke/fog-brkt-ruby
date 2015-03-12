describe "load balancer requests" do
  let(:load_balancer_format) do
    {
      "id"                       => String,
      "customer"                 => String,
      "name"                     => String,
      "workload"                 => String,
      "billing_group"            => String,
      "security_group"           => String,
      "daily_cost"               => String,
      "description"              => String,
      "service_name_fqdn"        => Fog::Nullable::String,
      "service_name"             => String,
      "healthy_threshold"        => Integer,
      "modified_time"            => String,
      "unhealthy_threshold"      => Integer,
      "cost"                     => String,
      "created_by"               => String,
      "created_time"             => String,
      "fixed_charge"             => String,
      "base_hourly_rate"         => String,
      "health_check_target"      => String,
      "modified_by"              => String,
      "requested_state"          => String,
      # "health_check_listener"    => nil, # not sure about format
      "instances_security_group" => String,
      "hourly_cost"              => String,
      "health_check_interval"    => Integer,
      "monthly_cost"             => String,
      # "instances_out_of_service" => nil, # not sure about format
      # "instances_in_service"     => nil, # not sure about format
      "health_check_timeout"     => Integer,
      "metadata"                 => Hash,
      "provider_load_balancer"   => {
        "dns_name" => String,
        "state"    => String,
        "why"      => String
      }
    }
  end

  before(:all) do
    @cell = create_computing_cell
    billing_group = compute.billing_groups.create(
      :customer_id => compute.customer.id,
      :name        => Fog::Brkt::Mock.name
    )
    @security_group = compute.security_groups.create(
      :name    => Fog::Brkt::Mock.name,
      :network => @cell.network.id
    )
    @workload = compute.workloads.create(
      :billing_group_id => billing_group.id,
      :zone_id          => @cell.zones.first.id,
      :name             => Fog::Brkt::Mock.name
    )
  end

  after(:all) do
    delete_computing_cell(@cell)
  end

  describe "#create_load_balancer" do
    before(:all) do
      @lb_name = Fog::Brkt::Mock.name
      @response = compute.create_load_balancer({
        :name           => @lb_name,
        :workload       => @workload.id,
        :security_group => @security_group.id
      })
    end

    after(:all) { compute.delete_load_balancer(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(load_balancer_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @lb_name }
      it { expect(subject["workload"]).to eq @workload.id }
      it { expect(subject["security_group"]).to eq @security_group.id }
      it { expect(subject["billing_group"]).to eq @workload.billing_group }
    end
  end

  describe "#list_load_balancers" do
    before(:all) do
      @lb = compute.load_balancers.create({
        :name           => Fog::Brkt::Mock.name,
        :workload       => @workload.id,
        :security_group => @security_group.id
      })
    end

    after(:all) { @lb.destroy }

    describe "response" do
      subject { compute.list_load_balancers.body }

      it { is_expected.to have_format([load_balancer_format]) }
    end
  end
end
