module Headlines
  describe DataAlexa::Domain do
    let(:alexa_data) { open_fixture("alexa_data.xml").read }

    subject(:data) { described_class.new(alexa_data) }

    its(:description) { is_expected.to eq "Flipkart is a leading destination for online shopping in India." }
    its(:country_name) { is_expected.to eq "India" }
    its(:country_code) { is_expected.to eq "IN" }

    describe "#catecories" do
      subject(:categories) { data.categories }

      its(:count) { is_expected.to eq 2 }
      its(:first) { is_expected.to be_kind_of(DataAlexa::Category) }
    end
  end
end
