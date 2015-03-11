describe "volume requests" do
  let(:volume_format) do
    {
      "id"                          => String,
      "name"                        => String,
      "description"                 => String,
      "customer"                    => String,
      "provider_bracket_volume"     => {"state" => String, "why" => String},
      "expired"                     => Fog::Boolean,
      "deleted"                     => Fog::Boolean,
      "daily_cost"                  => String,
      "cost"                        => String,
      "parent"                      => Fog::Nullable::String,
      "lease_expire_time"           => Fog::Nullable::String,
      "modified_time"               => String,
      "large_io"                    => Fog::Boolean,
      "min_iops"                    => Integer,
      "iops"                        => Integer,
      "hourly_cost"                 => String,
      "fixed_charge"                => String,
      "created_time"                => String,
      "modified_by"                 => String,
      "base_hourly_rate"            => String,
      "iscsi_target_ip"             => Fog::Nullable::String,
      "children"                    => String,
      "billing_group"               => String,
      "min_size"                    => Integer,
      "size_in_gb"                  => Integer,
      "remaining_gb"                => Integer,
      "is_readonly"                 => Fog::Boolean,
      "monthly_cost"                => String,
      "auto_snapshot_duration_days" => Integer,
      "remaining_iops"              => Integer,
      "slo"                         => Integer,
      "requested_state"             => String,
      "created_by"                  => String,
      "availability"                => Integer,
      "instance"                    => Fog::Nullable::String,
      "version"                     => Integer,
      "iops_max"                    => Integer,
      "computing_cell"              => String,
      "bracket_volume_template"     => Fog::Nullable::String,
      "metadata"                    => Hash
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
    @billing_group.destroy
    delete_computing_cell(@cell)
  end

  describe "#create_volume" do
    before(:all) do
      @volume_name = Fog::Brkt::Mock.name
      @response = compute.create_volume({
        :name           => @volume_name,
        :computing_cell => @cell.id,
        :billing_group  => @billing_group.id,
        :size_in_gb     => 10,
        :iops           => 100,
        :iops_max       => 200
      })
    end

    after(:all) do
      compute.delete_volume(@response.body["id"])
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(volume_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to           eq @volume_name }
      it { expect(subject["computing_cell"]).to eq @cell.id }
      it { expect(subject["billing_group"]).to  eq @billing_group.id }
      it { expect(subject["size_in_gb"]).to     eq 10 }
      it { expect(subject["iops"]).to           eq 100 }
    end
  end

  describe "#update_volume" do
    before(:all) do
      @volume = compute.volumes.create(
        :name              => Fog::Brkt::Mock.name,
        :computing_cell_id => @cell.id,
        :billing_group_id  => @billing_group.id,
        :size_in_gb        => 10,
        :iops              => 100,
        :iops_max          => 200
      )
      @response = compute.update_volume(@volume.id, {
        :name => "new name"
      })
    end

    after(:all) { @volume.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(volume_format) }
      it { expect(subject["name"]).to eq "new name" }
    end
  end

  describe "#list_volumes" do
    before(:all) do
      @volume1 = compute.volumes.create(
        :name              => Fog::Brkt::Mock.name,
        :computing_cell_id => @cell.id,
        :billing_group_id  => @billing_group.id,
        :size_in_gb        => 10,
        :iops              => 100,
        :iops_max          => 200
      )
      @volume2 = compute.volumes.create(
        :name              => Fog::Brkt::Mock.name,
        :computing_cell_id => @cell.id,
        :billing_group_id  => @billing_group.id,
        :size_in_gb        => 10,
        :iops              => 100,
        :iops_max          => 200
      )
    end

    after(:all) do
      @volume1.destroy
      @volume2.destroy
    end

    describe "response" do
      subject { compute.list_volumes.body }

      it { is_expected.to have_format([volume_format]) }
    end
  end

  # describe "#list_instance_volumes" do
  #   before(:all) do
  #     compute.volumes.create(
  #       :name              => Fog::Brkt::Mock.name,
  #       :computing_cell_id => @cell.id,
  #       :billing_group_id  => @billing_group.id,
  #       :size_in_gb        => 10
  #     )
  #   end

  #   describe "response" do
  #     subject { compute.list_instance_volumes("foobar").body }

  #     it { is_expected.to have_format([volume_format]) }
  #     it { expect(subject.size).to eq 1 }
  #   end
  # end
end
