describe "machine types requests" do
  let(:machine_type_format) do
    {
      "cpu_cores"            => Integer,
      "encrypted_storage_gb" => Float,
      "hourly_cost"          => String,
      "id"                   => String,
      "provider"             => Fog::Nullable::Integer,
      "ram"                  => Float,
      "storage_gb"           => Integer,
      "supports_pv"          => Fog::Boolean
    }
  end

  describe "#list_machine_types" do
    describe "response" do
      subject { compute.list_machine_types.body }

      it { is_expected.to have_format([machine_type_format]) }
    end
  end
end
