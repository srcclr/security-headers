module Headlines
  module SecurityHeaders
    describe XXssProtection do
      describe "#parse" do
        subject(:params) { described_class.new(header).params }

        context "with full header" do
          let(:header) { ["x-xss-protection", "1; mode=block"] }

          its([:enabled]) { is_expected.to be_truthy }
          its([:mode]) { is_expected.to eq "block" }
        end

        context "without mode property" do
          let(:header) { ["x-xss-protection", "1"] }

          its([:enabled]) { is_expected.to be_truthy }
          its([:mode]) { is_expected.to be_nil }
        end

        context "with disabled header" do
          let(:header) { ["x-xss-protection", "0"] }

          its([:enabled]) { is_expected.to eq false }
        end
      end
    end
  end
end
