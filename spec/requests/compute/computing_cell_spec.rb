describe "computing cell requests" do
  let(:computing_cell_format) do
    {
      "id"                      => String,
      "name"                    => String,
      "description"             => String,
      "customer"                => String,
      "created_by"              => String,
      "modified_by"             => String,
      "requested_state"         => String,
      "created_time"            => String,
      "modified_time"           => String,
      "member_groups"           => [String],
      "gateway_ip"              => String,
      "provider"                => String,
      "metadata"                => Hash,
      "provider_computing_cell" => Hash,
      "network" => {
        "id"               => String,
        "name"             => String,
        "customer"         => String,
        "modified_by"      => String,
        "description"      => String,
        "computing_cell"   => String,
        "requested_state"  => String,
        "modified_time"    => String,
        "zones"            => String,
        "created_by"       => String,
        "created_time"     => String,
        "cidr_block"       => String,
        "metadata"         => Hash,
        "provider_network" => {
          "state" => String,
          "why"   => String
        }
      }
    }
  end

  describe "#create_computing_cell" do
    before(:all) do
      @cell_name = Fog::Brkt::Mock.name
      @response = compute.create_computing_cell(@cell_name, "10.0.0.0/16", "AWS",
        {:aws_region => "us-west-2"})
    end

    after(:all) do
      compute.delete_computing_cell(@response.body["id"])
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(computing_cell_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @cell_name }
      it { expect(subject["provider"]).to eq "AWS" }
      it { expect(subject["network"]["cidr_block"]).to eq "10.0.0.0/16" }
    end
  end
end
