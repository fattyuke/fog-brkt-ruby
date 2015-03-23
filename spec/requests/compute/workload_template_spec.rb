describe "workload requests" do
  let(:workload_template_format) do
    {
      "id"                    => String,
      "name"                  => String,
      "description"           => String,
      "assigned_groups"       => Array,
      "assigned_zones"        => Array,
      "fixed_charge"          => String,
      "base_hourly_rate"      => String,
      "hourly_cost"           => String,
      "daily_cost"            => String,
      "monthly_cost"          => String,
      "max_cost"              => Fog::Nullable::String,
      "enable_service_domain" => Fog::Boolean,
      "workloads"             => String,
      "instance_templates"    => String,
      "created_time"          => String,
      "created_by"            => String,
      "modified_time"         => String,
      "modified_by"           => String,
      "customer"              => String,
      "errors"                => Hash,
      "state"                 => String,
      "last_deployed_time"    => Fog::Nullable::String,
      "metadata"              => Hash
    }
  end

  before(:all) do
    @cell = create_computing_cell
    @billing_group = compute.billing_groups.create(
      :customer_id => compute.customer.id,
      :name        => Fog::Brkt::Mock.name
    )
  end

  after(:all) do
    @billing_group.destroy if @billing_group
    delete_computing_cell(@cell)
  end

  describe "#create_workload_template" do
    before(:all) do
      @workload_template_name = Fog::Brkt::Mock.name
      @response = compute.create_workload_template({
        :name            => @workload_template_name,
        :assigned_groups => [@billing_group.id],
        :assigned_zones  => [@cell.zones.first.id]
      })
    end

    after(:all) { compute.delete_workload_template(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(workload_template_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @workload_template_name }
      it { expect(subject["assigned_groups"]).to eq [@billing_group.id] }
      it { expect(subject["assigned_zones"]).to eq [@cell.zones.first.id] }
    end
  end

 describe "#update_workload_template" do
    before(:all) do
      @workload_template = compute.workload_templates.create({
        :name          => Fog::Brkt::Mock.name,
        :assigned_groups => [@billing_group.id],
        :assigned_zones  => [@cell.zones.first.id]
      })
      @response = compute.update_workload_template(@workload_template.id, { :name => "new name"} )
    end

    after(:all) { @workload_template.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(workload_template_format) }
      it { expect(subject["name"]).to eq "new name" }
    end
  end

  describe "#list_workload_templates" do
    before(:all) do
      @workload_template = compute.workload_templates.create({
        :name          => Fog::Brkt::Mock.name,
        :assigned_groups => [@billing_group.id],
        :assigned_zones  => [@cell.zones.first.id]
      })
    end

    describe "response" do
      subject { compute.list_workload_templates.body }

      it { is_expected.to have_format([workload_template_format]) }
    end
  end

  describe "#get_workload_template" do
    before(:all) do
      @workload_template = compute.workload_templates.create({
        :name          => Fog::Brkt::Mock.name,
        :assigned_groups => [@billing_group.id],
        :assigned_zones  => [@cell.zones.first.id]
      })
      @response = compute.get_workload_template(@workload_template.id)
    end

    after(:all) { @workload_template.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(workload_template_format) }
    end
  end
end
