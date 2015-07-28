module Headlines
  module SecurityHeaders
    describe XXssProtection do
      let(:name) { "x-xss-protection" }

      describe "#parse" do
        subject(:params) { described_class.new(name, value).params }

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

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "for header with all parameters" do
          context "with mode=block parameter" do
            let(:value) { "1; mode=block" }

            it { is_expected.to eq 2 }
          end

          context "with another mode parameter" do
            let(:value) { "1; mode=wrong" }

            it { is_expected.to eq 1 }
          end
        end

        context "for enabled header" do
          let(:value) { "1" }

          it { is_expected.to eq 1 }
        end

        context "for disabled header" do
          let(:value) { "0" }

          it { is_expected.to eq(-1) }
        end

        context "without header" do
          let(:value) { "" }

          it { is_expected.to eq(-1) }
        end
      end
    end
  end
end
