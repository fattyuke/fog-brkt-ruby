describe "billing group requests" do
  let(:billing_group_format) do
    {
      'customer'          => String,
      'spent_cost'        => String,
      'modified_by'       => String,
      'name'              => String,
      'refundable_cost'   => String,
      'description'       => Fog::Nullable::String,
      'created_by'        => String,
      'allocated_cost'    => String,
      'allocated_balance' => String,
      'modified_time'     => String,
      'members'           => String,
      'number_of_members' => Integer,
      'created_time'      => String,
      'metadata'          => Hash,
      'max_hourly_rate'   => Fog::Nullable::Integer,
      'id'                => String,
      'parent_balance'    => String
    }
  end

  describe "#create_billing_group" do
    before(:all) do
      @group_name = Fog::Brkt::Mock.name
      @response = compute.create_billing_group(compute.customer.id, @group_name, {
        description: "description",
        members:     ["user@example.com"]
      })
      @billing_group_id = @response.body["id"]
    end

    after(:all) { compute.delete_billing_group(@billing_group_id) }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format(billing_group_format) }
      it { expect(subject["id"]).to_not be_nil }
      it { expect(subject["customer"]).to eq compute.customer.id }
      it { expect(subject["name"]).to eq @group_name }
      it { expect(subject["description"]).to eq "description" }
      it { expect(subject["number_of_members"]).to eq 1 }
    end
  end

  describe "#list_billing_groups" do
    before(:all) do
      @billing_group = compute.billing_groups.create(
        :customer_id => compute.customer.id,
        :name        => Fog::Brkt::Mock.name
      )
      @response = compute.list_billing_groups
    end

    after(:all) { @billing_group.destroy }

    describe "response" do
      subject { @response.body }

      it { is_expected.to have_format([billing_group_format]) }
    end
  end
end
