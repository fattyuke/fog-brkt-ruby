describe "images requests" do
  let(:image_format) do
    {
      "customer"           => Fog::Nullable::String,
      "os_settings"        => Hash,
      "modified_by"        => Fog::Nullable::String,
      "description"        => String,
      "unencrypted_parent" => Fog::Nullable::String,
      "csp_images"         => String,
      "created_by"         => Fog::Nullable::String,
      "is_encrypted"       => Fog::Boolean,
      "metadata"           => Hash,
      "state"              => String,
      "modified_time"      => String,
      "created_time"       => String,
      "is_base"            => Fog::Boolean,
      "os"                 => {
        "name"          => String,
        "customer"      => Fog::Nullable::String,
        "created_by"    => Fog::Nullable::String,
        "modified_by"   => Fog::Nullable::String,
        "description"   => String,
        "os_features"   => Hash,
        "modified_time" => String,
        "label"         => String,
        "platform"      => String,
        "version"       => String,
        "created_time"  => String,
        "metadata"      => Hash,
        "id"            => String
      },
      "id"                 => String,
      "name"               => String
    }
  end

  describe "#list_images" do
    describe "response" do
      subject { compute.list_images.body }

      it { is_expected.to have_format([image_format]) }
    end
  end
end
