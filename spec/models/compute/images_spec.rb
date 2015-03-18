describe Fog::Compute::Brkt::Images do
  describe "#get" do
    context "found" do
      it "returns Image instance" do
        response = Excon::Response.new(:body => {})
        expect(compute).to receive(:get_image).with("foo").and_return(response)
        expect(compute.images.get("foo")).to be_instance_of Fog::Compute::Brkt::Image
      end
    end

    context "not found" do
      it "returns nil" do
        not_found_error = Excon::Errors::NotFound.new("not found")
        expect(compute).to receive(:get_image).with("foo").and_raise(not_found_error)
        expect(compute.images.get("foo")).to be_nil
      end
    end
  end
end
