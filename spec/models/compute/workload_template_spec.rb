describe Fog::Compute::Brkt::WorkloadTemplate do
  def new_workload_template(arguments={})
    Fog::Compute::Brkt::WorkloadTemplate.new(arguments.merge(:service => compute))
  end

  describe "#save" do
    context "new record" do
      it "requires name" do
        workload_template = new_workload_template({
          :assigned_groups => ["foo"],
          :assigned_zones => ["bar"],
        })
        expect { workload_template.save }.to raise_error(ArgumentError)
      end

      it "requires assigned_groups" do
        workload_template = new_workload_template({
          :name => "foo",
          :assigned_zones => ["bar"],
        })
        expect { workload_template.save }.to raise_error(ArgumentError)
      end

      it "requires assigned_groups to not be empty" do
        workload_template = new_workload_template({
          :name => "foo",
          :assigned_groups => [],
          :assigned_zones => ["bar"],
        })
        expect { workload_template.save }.to raise_error(ArgumentError)
      end

      it "requires assigned_zones" do
        workload_template = new_workload_template({
          :name => "foo",
          :assigned_groups => ["bar"],
        })
        expect { workload_template.save }.to raise_error(ArgumentError)
      end

      it "requires assigned_zones to not be empty" do
        workload_template = new_workload_template({
          :name => "foo",
          :assigned_groups => ["foo"],
          :assigned_zones => [],
        })
        expect { workload_template.save }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#publish!" do
    context "when not persisted" do
      let(:workload_template) { new_workload_template }

      it "raises an error" do
        expect { workload_template.publish! }.to raise_error(ArgumentError)
      end
    end

    context "when persisted" do
      it "raises an error if already published" do
        workload_template = new_workload_template({
          :id => "foo",
          :state => described_class::State::PUBLISHED
        })
        expect { workload_template.publish! }.to raise_error(ArgumentError)
      end

      it "published if wasnt published" do
        workload_template = new_workload_template({
          :id => "foo",
          :state => described_class::State::DRAFT
        })
        response = double("response", :body => {})
        expect(compute).to receive(:update_workload_template).and_return(response)
        workload_template.publish!
        expect(workload_template).to be_published
      end
    end
  end
end
