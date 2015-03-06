describe "workload requests" do
  let(:workload_format) do
    {
      "billing_group"       => String,
      "created_by"          => String,
      "created_time"        => String,
      "customer"            => String,
      "deleted"             => Fog::Boolean,
      "description"         => Fog::Nullable::String,
      "expired"             => Fog::Boolean,
      "id"                  => String,
      "instances"           => String,
      "lease_expire_time"   => Fog::Nullable::String,
      "lease_modified_time" => String,
      "max_cost"            => Fog::Nullable::String,
      "modified_by"         => String,
      "modified_time"       => String,
      "name"                => String,
      "requested_state"     => String,
      "service_domain"      => Fog::Nullable::String,
      "state"               => String,
      "workload_template"   => Fog::Nullable::String,
      "zone"                => String,
    }
  end

  before(:all) do
    @cell = compute.computing_cells.create({
      :name    => Fog::Brkt::Mock.name,
      :network => { :cidr_block => "10.0.0.0/16" }
    })
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

  describe "#create_workload" do
    before(:all) do
      @workload_name = Fog::Brkt::Mock.name
      @response = compute.create_workload(@billing_group.id, @workload_name, @cell.zones.first.id)
    end

    after(:all) { compute.delete_workload(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(workload_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @workload_name }
    end
  end

  describe "#list_workloads" do
    before(:all) { @response = compute.list_workloads }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format([workload_format]) }
    end
  end
end
