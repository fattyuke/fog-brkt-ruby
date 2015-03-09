describe "volume requests" do
  let(:volume_format) do
    {
      "id"                          => String,
      "name"                        => String,
      "billing_group"               => String,
      "computing_cell"              => String,
      "description"                 => String,
      "auto_snapshot_duration_days" => Integer,
      "availability"                => Integer,
      "bracket_volume_template"     => Fog::Nullable::String,
      "children"                    => String,
      "created_by"                  => String,
      "created_time"                => String,
      "customer"                    => String,
      "hourly_cost"                 => Fog::Nullable::String,
      "daily_cost"                  => Fog::Nullable::String,
      "monthly_cost"                => Fog::Nullable::String,
      "deleted"                     => Fog::Boolean,
      "expired"                     => Fog::Boolean,
      "instance"                    => Fog::Nullable::String,
      "iops"                        => Integer,
      "iops_max"                    => Integer,
      "is_readonly"                 => Fog::Boolean,
      "iscsi_target_ip"             => String,
      "large_io"                    => Fog::Boolean,
      "lease_expire_time"           => String,
      "metadata"                    => Hash,
      "min_iops"                    => Integer,
      "min_size"                    => Integer,
      "modified_by"                 => String,
      "modified_time"               => String,
      "parent"                      => Fog::Nullable::String,
      "provider_bracket_volume"     => {
        "state" => String,
        "why"   => String
      },
      "remaining_gb"                => Integer,
      "remaining_iops"              => Integer,
      "requested_state"             => String,
      "size_in_gb"                  => Integer,
      "slo"                         => Integer,
      "version"                     => Integer
    }
  end

  before(:all) do
    @cell = compute.computing_cells.create(
      :name    => Fog::Brkt::Mock.name,
      :network => { :cidr => "10.0.0.0/16" }
    )
    @billing_group = compute.billing_groups.create(
      :customer_id => customer_id,
      :name        => Fog::Brkt::Mock.name
    )
  end

  after(:all) do
    @billing_group.destroy
    @cell.destroy
    # wait while computing cell will be deleted completely and API will return 404
    # to prevent hitting the limit
    Fog.wait_for { @cell.completely_deleted? }
  end

  describe "#create_volume" do
    before(:all) do
      @volume_name = Fog::Brkt::Mock.name
      @response = compute.create_volume(@volume_name, @cell.id, @billing_group.id)
    end

    describe "response" do
      # TODO: remove this condition when bug fixed
      if Fog.mock?
        subject { @response.body }

        it { is_expected.to have_format(volume_format) }
        it { expect(subject["id"]).to_not be_nil }
        it { expect(subject["name"]).to           eq @volume_name }
        it { expect(subject["computing_cell"]).to eq @cell.id }
        it { expect(subject["billing_group"]).to  eq @billing_group.id }
      else
        pending
      end
    end
  end
end
