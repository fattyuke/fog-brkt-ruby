describe "server template requests" do
  machine_type = compute.machine_types.first
  image        = compute.images.first

  let(:server_template_format) do
    {
      "id"                       => String,
      "name"                     => String,
      "description"              => String,
      "service_name"             => String,
      "workload_template"        => String,
      "customer"                 => String,
      "assigned_groups"          => Array,
      "security_groups"          => Array,
      "load_balancer_template"   => Fog::Nullable::String,
      "machine_type"             => Fog::Nullable::String,
      "requires_ssd"             => Fog::Boolean,
      "requires_encryption"      => Fog::Boolean,
      "min_quantity"             => Integer,
      "cpu_arch"                 => String,
      "cpu_cores_minimum"        => Integer,
      "ram_minimum"              => Integer,
      "requires_gpu"             => Fog::Boolean,
      "fixed_charge"             => String,
      "base_hourly_rate"         => String,
      "hourly_cost"              => String,
      "daily_cost"               => String,
      "monthly_cost"             => String,
      # "cloudinit_data"           => nil, ???
      "instances"                => String,
      "errors"                   => Hash,
      "created_by"               => String,
      "created_time"             => String,
      "modified_by"              => String,
      "modified_time"            => String,
      "cloudinit_id"             => String,
      "cloudinit_script"         => String,
      "cloudinit_type"           => String,
      "bracket_volume_templates" => String,
      # "cloudinit_config"         => nil, ???
      "internet_accessible"      => Fog::Boolean,
      "metadata"                 => Hash,
      "state"                    => String,
      "image_definition"         => Hash
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
    delete_computing_cell(@cell) if @cell
    @billing_group.destroy if @billing_group
  end

  describe "#create_server_template" do
    before(:all) do
      @server_template_name = Fog::Brkt::Mock.name
      @response = compute.create_server_template(@workload_template.id, {
        :name             => @server_template_name,
        :image_definition => image.id
      })
    end

    after(:all) { compute.delete_server_template(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_template_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @server_template_name }
      it { expect(subject["workload_template"]).to eq @workload_template.id }
      it { expect(subject["assigned_groups"]).to eq @workload_template.assigned_groups }
      it { expect(subject["image_definition"]["id"]).to eq image.id }
    end
  end

  describe "#get_server_template" do
    before(:all) do
      @server_template = compute.server_templates.create(
        :name              => Fog::Brkt::Mock.name,
        :workload_template => @workload_template.id,
        :image_definition  => image.id
      )
    end

    after(:all) { @server_template.destroy }

    describe "response" do
      subject { compute.get_server_template(@server_template.id).body }

      it { is_expected.to have_format(server_template_format) }
    end
  end

  describe "#update_server_template" do
    before(:all) do
      @server_template = compute.server_templates.create(
        :name              => Fog::Brkt::Mock.name,
        :workload_template => @workload_template.id,
        :image_definition  => image.id
      )
      @response = compute.update_server_template(@server_template.id, {})
    end

    after(:all) { @server_template.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(server_template_format) }
    end
  end

  describe "#list_workload_template_server_templates" do
    before(:all) do
      @server_template = compute.server_templates.create(
        :name              => Fog::Brkt::Mock.name,
        :workload_template => @workload_template.id,
        :image_definition  => image.id
      )
    end

    after(:all) { @server_template.destroy }

    describe "response" do
      subject { compute.list_workload_template_server_templates(@workload_template.id).body }

      it { is_expected.to have_format([server_template_format]) }
      it { expect(subject.size).to eq 1 }
    end
  end
end
