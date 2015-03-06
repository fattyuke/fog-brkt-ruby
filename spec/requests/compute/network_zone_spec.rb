describe "network zone requests" do
  let(:zone_format) do
    {
      "customer"             => String,
      "use_main_route_table" => Fog::Boolean,
      "network"              => String,
      "description"          => Fog::Nullable::String,
      "modified_time"        => String,
      "requested_state"      => String,
      "created_by"           => String,
      "provider_zone"        => {
        "state" => String,
        "why"   => String
      },
      "created_time"         => String,
      "modified_by"          => String,
      "cidr_block"           => String,
      "metadata"             => Hash,
      "id"                   => String,
      "name"                 => String
    }
  end

  describe "#create_network_zone" do
    before(:all) do
      @cell = compute.computing_cells.create({
        :name    => Fog::Brkt::Mock.name,
        :network => { :cidr_block => "10.0.0.0/16" }
      })
      @zone_name = Fog::Brkt::Mock.name
      @response = compute.create_network_zone(@cell.network.id, "10.0.0.0/18", @zone_name)
    end

    after(:all) do
      compute.delete_network_zone(@response.body["id"])
      @cell.destroy
      # wait while computing cell will be deleted completely and API will return 404
      # to prevent hitting the limit
      Fog.wait_for { @cell.completely_deleted? }
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(zone_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @zone_name }
      it { expect(subject["cidr_block"]).to eq "10.0.0.0/18" }
      it { expect(subject["network"]).to eq @cell.network.id }
    end
  end

  describe "#list_network_zones" do
    describe "response" do
      subject { compute.list_network_zones.body }

      it { is_expected.to have_format([zone_format]) }
    end
  end
end
