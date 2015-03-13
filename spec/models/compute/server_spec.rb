describe Fog::Compute::Brkt::Server do
  def new_server(arguments={})
    Fog::Compute::Brkt::Server.new(arguments.merge(:service => compute))
  end

  describe "#ready?" do
    specify { expect(new_server).to_not be_ready }
    specify { expect(new_server(:provider_instance => {"state" => "INITIALIZING"})).to_not be_ready }
    specify { expect(new_server(:provider_instance => {"state" => "READY"})).to be_ready }
  end

  describe "volumes" do
    before(:all) do
      @cell = create_computing_cell
      @billing_group = compute.billing_groups.create(
        :customer_id => compute.customer.id,
        :name        => Fog::Brkt::Mock.name
      )
      @workload = compute.workloads.create(
        :billing_group_id => @billing_group.id,
        :zone_id          => @cell.zones.first.id,
        :name             => Fog::Brkt::Mock.name
      )
      @server = compute.servers.create({
        :name            => Fog::Brkt::Mock.name,
        :image_id        => compute.images.first.id,
        :machine_type_id => compute.machine_types.first.id,
        :workload        => @workload.id
      })
    end

    after(:all) do
      delete_computing_cell(@cell) if @cell
      @billing_group.destroy if @billing_group
    end

    describe "#attach_volume" do
      let(:volume) do
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10,
          :iops              => 100,
          :iops_max          => 200
        )
      end

      before { @server.attach_volume(volume) }

      it { expect(volume.instance).to eq @server.id }
    end

    describe "#attached?" do
      let(:volume) do
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10,
          :iops              => 100,
          :iops_max          => 200,
          :instance          => @server.id
        )
      end
      let(:not_attached_volume) do
        compute.volumes.create(
          :name              => Fog::Brkt::Mock.name,
          :computing_cell_id => @cell.id,
          :billing_group_id  => @billing_group.id,
          :size_in_gb        => 10,
          :iops              => 100,
          :iops_max          => 200
        )
      end

      it { expect(@server.attached?(volume)).to eq true }
      it { expect(@server.attached?(not_attached_volume)).to eq false }
    end
  end
end
