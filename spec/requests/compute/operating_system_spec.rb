describe "operating system requests" do
  let(:os_format) do
    {
      "id"            => String,
      "name"          => String,
      "version"       => String,
      "label"         => String,
      "platform"      => String,
      "description"   => String,
      "os_features"   => Hash,
      "customer"      => Fog::Nullable::String,
      "created_by"    => Fog::Nullable::String,
      "created_time"  => String,
      "modified_by"   => Fog::Nullable::String,
      "modified_time" => String,
      "metadata"      => Hash
    }
  end

  describe "#list_operating_systems" do
    describe "response" do
      subject { compute.list_operating_systems.body }

      it { is_expected.to have_format([os_format]) }
    end
  end

  describe "#get_operating_system" do
    let(:oses) { compute.operating_systems }

    describe "response" do
      subject { compute.get_operating_system(oses.first.id).body }

      it { is_expected.to have_format(os_format) }
    end
  end
end
