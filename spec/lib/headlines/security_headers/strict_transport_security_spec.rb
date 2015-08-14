module Headlines
  module SecurityHeaders
    describe StrictTransportSecurity do
      describe "#score" do
        let(:name) { "strict-transport-security" }

        subject(:score) { described_class.new(name, value).score }

        context "when header contains max-age value higher then 31536000" do
          let(:value) { "max-age=631138519" }

          it { is_expected.to eq(1) }

          context "when header includes includeSubDomains parameter" do
            let(:value) { "max-age=631138519; includeSubDomains" }

            it { is_expected.to eq(2) }
          end
        end

        context "when header contains zero max-age value" do
          let(:value) { "max-age=0" }

          it { is_expected.to eq(-1) }
        end

        context "when header has wrong value" do
          let(:value) { "wrong value" }

          it { is_expected.to eq(-1) }
        end
      end
    end
  end
end
