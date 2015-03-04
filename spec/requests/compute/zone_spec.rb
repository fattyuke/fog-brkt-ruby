describe "zone requests" do
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

  describe "#list_zones" do
    before(:all) { @response = compute.list_zones }

    describe "response" do
      subject { @response.body }

      it do
        # TODO: remove pending
        pending if Fog.mocking?
        is_expected.to have_format([zone_format])
      end
    end
  end
end
