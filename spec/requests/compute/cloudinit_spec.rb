describe "cloudinit requests" do
  let(:cloudinit_format) do
    {
      "id"                  => String,
      "customer"            => String,
      "name"                => String,
      "description"         => Fog::Nullable::String,
      "deployment_type"     => String,
      "user_script"         => Fog::Nullable::String,
      "cloud_config"        => Fog::Nullable::String,
      "user_data"           => Fog::Nullable::String,
      "created_by"          => String,
      "modified_by"         => String,
      "created_time"        => String,
      "modified_time"       => String,
      "metadata"            => Hash
    }
  end

  describe "#create_cloudinit" do
    before(:all) do
      @cloudinit_name = Fog::Brkt::Mock.name
      @response = compute.create_cloudinit(
        :name => @cloudinit_name,
        :description => "description")
    end

    after(:all) { compute.delete_cloudinit(@response.body["id"]) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(cloudinit_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["name"]).to eq @cloudinit_name }
    end
  end

  describe "#update_cloudinit" do
    before(:all) do
      @cloudinit = compute.cloudinits.create({
        :name            => Fog::Brkt::Mock.name,
        :deployment_type => "DEFAULT"
      })
      @response = compute.update_cloudinit(@cloudinit.id, { :name => "new name"} )
    end

    after(:all) { @cloudinit.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(cloudinit_format) }
      it { expect(subject["name"]).to eq "new name" }
    end
  end

  describe "#list_cloudinits" do
    before(:all) {
      compute.create_cloudinit(
        :name => Fog::Brkt::Mock.name,
        :description => "description")
      @response = compute.list_cloudinits
    }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format([cloudinit_format]) }
    end
  end

  describe "#get_cloudinit" do
    before(:all) do
      @cloudinit = compute.cloudinits.create({
        :name            => "hello",
        :deployment_type => "DEFAULT"
      })
      @response = compute.get_cloudinit(@cloudinit.id)
    end

    after(:all) { @cloudinit.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(cloudinit_format) }
    end
  end
end