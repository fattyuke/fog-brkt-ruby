describe "volume template requests" do
  let(:volume_template_format) do
    {
      "id"                          => String,
      "instance_template"           => String,
      "name"                        => String,
      "description"                 => String,
      "parent"                      => Fog::Nullable::String,
      "customer"                    => String,
      "assigned_groups"             => Array,
      "size_in_gb"                  => Integer,
      "iops"                        => Integer,
      "iops_max"                    => Integer,
      "is_readonly"                 => Fog::Boolean,
      "auto_snapshot_duration_days" => Integer,
      "large_io"                    => Fog::Boolean,
      "availability"                => Integer,
      "slo"                         => Integer,
      "fs_label"                    => String,
      "fs_type"                     => Fog::Nullable::String,
      "fs_mount"                    => String,
      "attach_point"                => String,
      "fixed_charge"                => String,
      "base_hourly_rate"            => String,
      "hourly_cost"                 => String,
      "daily_cost"                  => String,
      "monthly_cost"                => String,
      "created_by"                  => String,
      "created_time"                => String,
      "modified_by"                 => String,
      "modified_time"               => String,
      "state"                       => String,
      "errors"                      => Hash,
      "metadata"                    => Hash
    }
  end

  before(:all) do
    @cell = create_computing_cell
    @billing_group = compute.billing_groups.create(
      :customer_id => compute.customer.id,
      :name        => Fog::Brkt::Mock.name
    )
    @workload_template = compute.workload_templates.create({
      :name            => Fog::Brkt::Mock.name,
      :assigned_groups => [@billing_group.id],
      :assigned_zones  => [@cell.zones.first.id]
    })
    @server_template = compute.server_templates.create(
      :name              => Fog::Brkt::Mock.name,
      :workload_template => @workload_template.id,
      :image_definition  => compute.images.first.id
    )
  end

  after(:all) do
    @server_template.destroy if @server_template
    @workload_template.destroy if @workload_template
    # @billing_group.destroy if @billing_group
    delete_computing_cell(@cell) if @cell
  end

  describe "#create_volume_template" do
    before(:all) do
      @volume_template_name = Fog::Brkt::Mock.name
      @response = compute.create_volume_template(@server_template.id, {
        :name           => @volume_template_name,
        :size_in_gb     => 10,
        :iops           => 100
      })
    end

    after(:all) { compute.delete_volume_template(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(volume_template_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @volume_template_name }
      it { expect(subject["assigned_groups"]).to eq @workload_template.assigned_groups }
      it { expect(subject["size_in_gb"]).to eq 10 }
      it { expect(subject["iops"]).to eq 100 }
    end
  end

  describe "#list_volume_templates" do
    before(:all) do
      @volume_template = compute.volume_templates.create(
        :name              => Fog::Brkt::Mock.name,
        :instance_template => @server_template.id,
        :size_in_gb        => 10,
        :iops              => 100
      )
    end

    after(:all) { @volume_template.destroy }

    describe "response" do
      subject { compute.list_volume_templates(@server_template.id).body }

      it { is_expected.to have_format([volume_template_format]) }
      it { expect(subject.size).to eq 1 }
    end
  end
end
