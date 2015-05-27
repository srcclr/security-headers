module Headlines
  describe DataAlexa do
    def build_url(url)
      "#{described_class::URL}&url=#{url}"
    end

    let(:domain) { "flipkart.com" }
    let(:alexa_data) { open_fixture("alexa_data.xml").read }

    subject(:data) { described_class.new(domain) }

    before do
      stub_request(:get, build_url(domain)).and_return(
        body: alexa_data,
        status: 200
      )
    end

    its(:xml) { is_expected.to eq alexa_data }
  end
end
