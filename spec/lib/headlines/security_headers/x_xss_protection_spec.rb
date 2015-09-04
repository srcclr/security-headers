module Headlines
  module SecurityHeaders
    describe XXssProtection do
      let(:name) { "x-xss-protection" }

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
