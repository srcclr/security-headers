module Headlines
  module SecurityHeaders
    describe XXssProtection do
      describe "#parse" do
        subject(:params) { described_class.new(value).params }

        describe "header with enable status" do
          context "without extra parameter" do
            let(:value) { "1" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:mode]) { is_expected.to be_nil }
          end

          context "with mode parameter" do
            let(:value) { "1; mode=block" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:mode]) { is_expected.to eq "block" }
          end

          context "with report parameter" do
            let(:value) { "1; report=http://example.com/report" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:report_url]) { is_expected.to eq "http://example.com/report" }
          end

          context "with space seperate parameters" do
            let(:value) { "1 mode=block" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:mode]) { is_expected.to be_nil }
          end
        end

        describe "header with disable status" do
          context "without extra parameters" do
            let(:value) { "0" }

            its([:enabled]) { is_expected.to eq false }
            its([:mode]) { is_expected.to be_nil }
            its([:report_url]) { is_expected.to be_nil }
          end

          context "with mode parameter" do
            let(:value) { "0; mode=block" }

            its([:enabled]) { is_expected.to eq false }
            its([:mode]) { is_expected.to be_nil }
          end
        end
      end
    end
  end
end
