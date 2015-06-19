require "rails_helper"

module Headlines
  describe ImportDomains do
    describe ".call" do
      let(:rows) { ["1,google.com", "2,facebook.com"] }
      let(:data_alexa) { open_fixture("alexa_data.xml").read }

      before do
        allow_any_instance_of(DataAlexa).to receive(:xml).and_return(data_alexa)
      end

      subject(:imported_domains) do
        described_class.call(rows: rows).domains
      end

      it "creates domains with appropriate country codes" do
        expect(imported_domains.map(&:country_code)).to eq(2.times.map { "IN" })
      end
    end
  end
end
