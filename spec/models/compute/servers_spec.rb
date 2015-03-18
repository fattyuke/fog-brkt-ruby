describe Fog::Compute::Brkt::Servers do
  describe "#get" do
    context "found" do
      it "returns Server instance" do
        response = Excon::Response.new(:body => {})
        expect(compute).to receive(:get_server).with("foo").and_return(response)
        expect(compute.servers.get("foo")).to be_instance_of Fog::Compute::Brkt::Server
      end
    end

    context "not found" do
      it "returns nil" do
        not_found_error = Excon::Errors::NotFound.new("not found")
        expect(compute).to receive(:get_server).with("foo").and_raise(not_found_error)
        expect(compute.servers.get("foo")).to be_nil
      end
    end
  end
end
