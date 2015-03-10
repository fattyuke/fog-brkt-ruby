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

  if Fog.mock?
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
        @response = compute.create_volume(@volume_name, @cell.id, @billing_group.id, 10)
      end

      describe "response" do
        subject { @response.body }

        it { is_expected.to have_format(volume_format) }
        it { expect(subject["id"]).to_not be_nil }
        it { expect(subject["name"]).to           eq @volume_name }
        it { expect(subject["computing_cell"]).to eq @cell.id }
        it { expect(subject["billing_group"]).to  eq @billing_group.id }
        it { expect(subject["size_in_gb"]).to     eq 10 }
      end
    end

    describe "#list_volumes" do
      before(:all) do
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10
        )
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10
        )
      end

      describe "response" do
        subject { compute.list_volumes.body }

        it { is_expected.to have_format([volume_format]) }
        it { expect(subject.size).to eq 3 } # TODO: should be 2
      end
    end

    describe "#list_instance_volumes" do
      before(:all) do
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10
        )
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10,
          :instance_id       => "foobar"
        )
      end

      describe "response" do
        subject { compute.list_instance_volumes("foobar").body }

        it { is_expected.to have_format([volume_format]) }
        it { expect(subject.size).to eq 1 }
      end
    end
  else
    pending
  end
end
