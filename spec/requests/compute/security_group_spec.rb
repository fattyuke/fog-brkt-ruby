describe "security group requests" do
  let(:security_group_format) do
    {
      "id"                      => String,
      "name"                    => String,
      "description"             => String,
      "customer"                => String,
      "created_by"              => String,
      "modified_by"             => String,
      "created_time"            => String,
      "modified_time"           => String,
      "rules"                   => String,
      "requested_state"         => String,
      "provider_security_group" => {
        "state" => String,
        "why"   => String
      },
      "metadata"                => Hash
    }
  end

  before(:all) { @cell = create_computing_cell }
  after(:all) { delete_computing_cell(@cell) }

  describe "#create_security_group" do
    before(:all) do
      @sec_group_name = Fog::Brkt::Mock.name
      @response = compute.create_security_group(@cell.network.id, @sec_group_name)
    end

    after(:all) { compute.delete_security_group(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(security_group_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @sec_group_name }
    end
  end

  describe "#get_security_group" do
    before(:all) do
      @security_group = compute.security_groups.create(
        :name    => Fog::Brkt::Mock.name,
        :network => @cell.network.id
      )
      @response = compute.get_security_group(@security_group.id)
    end

    after(:all) { @security_group.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(security_group_format) }
    end
  end

  describe "#list_security_groups" do
    before(:all) do
      compute.security_groups.create(
        :name    => Fog::Brkt::Mock.name,
        :network => @cell.network.id
      )
    end

    describe "response" do
      subject { compute.list_security_groups.body }

      it { is_expected.to have_format([security_group_format]) }
    end
  end
end
