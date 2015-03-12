describe "image requests" do
  os_id = compute.operating_systems.first.id

  let(:image_format) do
    {
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
  end

  describe "#create_image" do
    before(:all) do
      @image_name = Fog::Brkt::Mock.name
      @response = compute.create_image({
        :name => @image_name,
        :os   => os_id
      })
    end

    after(:all) { compute.delete_image(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(image_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @image_name }
      it { expect(subject["os"]["id"]).to eq os_id }
    end
  end

  describe "#list_images" do
    describe "response" do
      subject { compute.list_images.body }

      it { is_expected.to have_format([image_format]) }
    end
  end

  describe "#list_os_images" do
    before(:all) do
      @image1 = compute.images.create({
        :name => Fog::Brkt::Mock.name,
        :os   => os_id
      })
      @image2 = compute.images.create({
        :name => Fog::Brkt::Mock.name,
        :os   => os_id
      })
    end

    after(:all) do
      @image1.destroy
      @image2.destroy
    end

    describe "response" do
      subject { compute.list_os_images(os_id).body }

      it { is_expected.to have_format([image_format]) }
    end
  end
end
