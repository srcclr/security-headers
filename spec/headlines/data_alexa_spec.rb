module Headlines
  describe DataAlexa do
    def build_url(url)
      "#{described_class::URL}&url=#{url}"
    end

    let(:domain) { "flipkart.com" }
    let(:alexa_data) { open_fixture("alexa_data.xml") }

    subject(:data) { described_class.new(domain) }

    before do
      stub_request(:get, build_url(domain)).and_return(body: alexa_data, status: 200)
    end

    its(:description) { is_expected.to eq "Flipkart is a leading destination for online shopping in India." }
    its(:country_name) { is_expected.to eq "India" }
    its(:country_code) { is_expected.to eq "IN" }

    describe "#catecories" do
      subject(:categories) { data.categories }

      its(:count) { is_expected.to eq 2 }
      its(:first) { is_expected.to be_kind_of(described_class::Category) }
    end
  end
end
