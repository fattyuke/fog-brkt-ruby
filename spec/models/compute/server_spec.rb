describe Fog::Compute::Brkt::Server do
  def new_server(arguments={})
    Fog::Compute::Brkt::Server.new(arguments.merge(:service => compute))
  end

  describe "#ready?" do
    specify { expect(new_server).to_not be_ready }
    specify { expect(new_server(:provider_instance => {"state" => "INITIALIZING"})).to_not be_ready }
    specify { expect(new_server(:provider_instance => {"state" => "READY"})).to be_ready }
  end
end
