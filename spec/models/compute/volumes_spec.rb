describe Fog::Compute::Brkt::Volumes do
  describe "#get" do
    context "found" do
      it "returns Volume instance" do
        response = Excon::Response.new(:body => {})
        expect(compute).to receive(:get_volume).with("foo").and_return(response)
        expect(compute.volumes.get("foo")).to be_instance_of Fog::Compute::Brkt::Volume
      end
    end

    context "not found" do
      it "returns nil" do
        not_found_error = Excon::Errors::NotFound.new("not found")
        expect(compute).to receive(:get_volume).with("foo").and_raise(not_found_error)
        expect(compute.volumes.get("foo")).to be_nil
      end
    end
  end
end
