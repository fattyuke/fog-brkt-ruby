describe "load balancer template requests" do
  let(:load_balancer_template_format) do
    {
      "id"                    => String,
      "name"                  => String,
      "description"           => String,
      "service_name"          => String,
      "workload_template"     => String,
      "security_group"        => Fog::Nullable::String,
      "customer"              => String,
      "healthy_threshold"     => Integer,
      "unhealthy_threshold"   => Integer,
      "health_check_timeout"  => Integer,
      "health_check_interval" => Integer,
      "health_check_listener" => Fog::Nullable::String,
      "health_check_target"   => String,
      "created_by"            => String,
      "created_time"          => String,
      "modified_by"           => String,
      "modified_time"         => String,
      "fixed_charge"          => String,
      "base_hourly_rate"      => String,
      "hourly_cost"           => String,
      "daily_cost"            => String,
      "monthly_cost"          => String,
      "state"                 => String,
      "metadata"              => Hash
    }
  end

  before(:all) do
    @cell = create_computing_cell
    @billing_group = compute.billing_groups.create(
      :customer_id => compute.customer.id,
      :name        => Fog::Brkt::Mock.name
    )
    @workload_template = compute.workload_templates.create(
      :name            => Fog::Brkt::Mock.name,
      :assigned_groups => [@billing_group.id],
      :assigned_zones  => [@cell.zones.first.id]
    )
  end

  after(:all) do
    @workload_template.destroy if @workload_template
    @billing_group.destroy if @billing_group
    delete_computing_cell(@cell)
  end

  describe "#create_load_balancer_template & #delete_load_balancer_template" do
    before(:all) do
      @lb_template_name = Fog::Brkt::Mock.name
      @response = compute.create_load_balancer_template({
        :name              => @lb_template_name,
        :workload_template => @workload_template.id
      })
    end

    after(:all) { compute.delete_load_balancer_template(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(load_balancer_template_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @lb_template_name }
      it { expect(subject["workload_template"]).to eq @workload_template.id }
    end
  end

  describe "#update_load_balancer_template" do
    before(:all) do
      @lb_tpl = compute.load_balancer_templates.create({
        :name              => Fog::Brkt::Mock.name,
        :workload_template => @workload_template.id
      })
      @response = compute.update_load_balancer_template(@lb_tpl.id, {
        :name => "new name"
      })
    end

    after(:all) { @lb_tpl.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(load_balancer_template_format) }
      it { expect(subject["name"]).to eq "new name" }
    end
  end

  describe "#list_load_balancer_templates" do
    before(:all) do
      @lb_tpl = compute.load_balancer_templates.create({
        :name              => Fog::Brkt::Mock.name,
        :workload_template => @workload_template.id
      })
    end

    after(:all) { @lb_tpl.destroy }

    describe "response" do
      subject { compute.list_load_balancer_templates.body }

      it { is_expected.to have_format([load_balancer_template_format]) }
    end
  end
end
