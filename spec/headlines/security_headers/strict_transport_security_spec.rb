module Headlines
  module SecurityHeaders
    describe StrictTransportSecurity do
      describe "#parse" do
        subject(:params) { described_class.new(header).params }

        context "with full header" do
          let(:header) { ["strict-transport-security", "max-age=631138519; includeSubDomains"] }

          its([:max_age]) { is_expected.to eq "631138519" }
          its([:includeSubDomains]) { is_expected.to be_truthy }
        end

        context "without includeSubDomains parameter" do
          let(:header) { ["strict-transport-security", "max-age=631138519"] }

          its([:max_age]) { is_expected.to eq "631138519" }
          its([:includeSubDomains]) { is_expected.to be_falsey }
        end

        context "without any parameter" do
          let(:header) { ["strict-transport-security", ""] }

          its([:max_age]) { is_expected.to be_nil }
          its([:includeSubDomains]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
