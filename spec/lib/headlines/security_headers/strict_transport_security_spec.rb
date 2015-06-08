module Headlines
  module SecurityHeaders
    describe StrictTransportSecurity do
      describe "#parse" do
        let(:name) { "strict-transport-security" }

        subject(:params) { described_class.new(name, value).params }

        context "header with right max-age parameter" do
          let(:value) { "max-age=631138519" }

          its([:enabled]) { is_expected.to be_truthy }
          its([:max_age]) { is_expected.to eq "631138519" }
        end

        context "header with zero max-age parameter" do
          let(:value) { "max-age=0" }

          its([:enabled]) { is_expected.to be_falsey }
        end

        context "header with includeSubDomains parameter" do
          let(:value) { "max-age=631138519; includeSubDomains" }

          its([:enabled]) { is_expected.to be_truthy }
          its([:max_age]) { is_expected.to eq "631138519" }
          its([:includeSubDomains]) { is_expected.to be_truthy }
        end

        context "header with wrong value" do
          let(:value) { "wrong value" }

          its([:enabled]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
