describe "security group rule requests" do
  let(:security_group_rule_format) do
    {
      "id"                 => String,
      "customer"           => String,
      "is_ingress"         => Fog::Boolean,
      "modified_by"        => String,
      "ip_proto"           => String,
      "cidr_ip"            => Fog::Nullable::String,
      "port_range_from"    => Fog::Nullable::Integer,
      "port_range_to"      => Fog::Nullable::Integer,
      "modified_time"      => String,
      "src_security_group" => Fog::Nullable::String,
      "created_by"         => String,
      "created_time"       => String,
      "security_group"     => String,
      "description"        => String
    }
  end

  before(:all) do
    @cell = create_computing_cell
    @security_group = compute.security_groups.create({
      :name    => Fog::Brkt::Mock.name,
      :network => @cell.network.id
    })
  end

  after(:all) do
    delete_computing_cell(@cell)
    @security_group.destroy
  end

  describe "#create_security_group_rule" do
    before(:all) do
      @response = compute.create_security_group_rule(@security_group.id, {
        :cidr_ip         => "10.0.0.0/16",
        :ip_proto        => "tcp",
        :port_range_from => 1,
        :port_range_to   => 65536
      })
    end

    after(:all) { compute.delete_security_group_rule(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(security_group_rule_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["cidr_ip"]).to eq "10.0.0.0/16" }
      it { expect(subject["ip_proto"]).to eq "tcp" }
      it { expect(subject["port_range_from"]).to eq 1 }
      it { expect(subject["port_range_to"]).to eq 65536 }
    end
  end

  describe "#list_security_group_rules" do
    before(:all) do
      @rule = compute.security_group_rules.create({
        :security_group  => @security_group.id,
        :cidr_ip         => "10.0.0.0/16",
        :ip_proto        => "tcp",
        :port_range_from => 1,
        :port_range_to   => 65536
      })
    end

    after(:all) { @rule.destroy }

    describe "response" do
      subject { compute.list_security_group_rules.body }

      it { is_expected.to have_format([security_group_rule_format]) }
    end
  end
end
