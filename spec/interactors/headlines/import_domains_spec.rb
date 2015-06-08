require "rails_helper"

module Headlines
  describe ImportDomains do
    describe ".call" do
      let(:file) { open_fixture("top_domains.csv") }
      let(:data_alexa) { open_fixture("alexa_data.xml").read }

      before do
        allow_any_instance_of(DataAlexa).to receive(:xml).and_return(data_alexa)
      end

      subject(:imported_domains) do
        described_class.call(file: TopMillionDomain.new(file: file)).domains
      end

      it "creates domains with appropriate country codes" do
        expect(imported_domains.map(&:country_code)).to eq(4.times.map { "IN" })
      end
    end
  end
end
