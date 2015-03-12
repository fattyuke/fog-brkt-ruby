describe "scp image requests" do
  os_id = compute.operating_systems.first.id

  let(:csp_image_format) do
    {
      "id"               => String,
      "customer"         => String,
      "provider"         => String,
      "csp_image_id"     => Fog::Nullable::String,
      "modified_by"      => String,
      "modified_time"    => String,
      "state"            => String,
      "created_by"       => String,
      "created_time"     => String,
      "csp_settings"     => Hash,
      "image_definition" => {
        "id"                 => String,
        "name"               => String,
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
        }
      }
    }
  end

  describe "#create_csp_image" do
    before(:all) do
      @image = compute.images.create({
        :name => Fog::Brkt::Mock.name,
        :os   => os_id
      })
      @response = compute.create_csp_image({
        :provider         => "AWS",
        :image_definition => @image.id
      })
    end

    after(:all) do
      @image.destroy
      compute.delete_csp_image(@response.body["id"])
    end

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(csp_image_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["provider"]).to eq "AWS" }
      it { expect(subject["image_definition"]["id"]).to eq @image.id }
    end
  end
end
