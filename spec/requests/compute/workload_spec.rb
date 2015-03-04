describe "workload requests" do
  zone_id = "df43995a1d8a48d28b835238bfd079b4"

  let(:workload_format) do
    {
      'billing_group'       => String,
      'created_by'          => String,
      'created_time'        => String,
      'customer'            => String,
      'deleted'             => Fog::Boolean,
      'description'         => Fog::Nullable::String,
      'expired'             => Fog::Boolean,
      'id'                  => String,
      'instances'           => String,
      'lease_expire_time'   => Fog::Nullable::String,
      'lease_modified_time' => String,
      'max_cost'            => Fog::Nullable::String,
      'modified_by'         => String,
      'modified_time'       => String,
      'name'                => String,
      'requested_state'     => String,
      'service_domain'      => Fog::Nullable::String,
      'state'               => String,
      'workload_template'   => Fog::Nullable::String,
      'zone'                => String,
    }
  end

  describe "#create_workload" do
    before(:all) do
      @workload_name = Fog::Brkt::Mock.name
      @billing_group = compute.billing_groups.create(
        :customer_id => customer_id,
        :name        => Fog::Brkt::Mock.name
      )
      @response = compute.create_workload(@billing_group.id, @workload_name, zone_id)
    end

    after(:all) do
      compute.delete_workload(@response.body["id"]) if @response
      @billing_group.destroy
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(workload_format) }
      it { expect(subject["name"]).to eq @workload_name }
      it { expect(subject["id"]).to_not be_nil }
    end
  end

  describe "#list_workloads" do
    before(:all) do
      @billing_group = compute.billing_groups.create(
        :customer_id => customer_id,
        :name        => Fog::Brkt::Mock.name
      )
      @workload = compute.workloads.create(
        :billing_group_id => @billing_group.id,
        :name             => Fog::Brkt::Mock.name,
        :zone_id          => zone_id
      )
      @response = compute.list_workloads
    end

    after(:all) do
      @workload.destroy
      @billing_group.destroy
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format([workload_format]) }
    end
  end
end