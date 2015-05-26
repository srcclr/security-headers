module Headlines
  module SecurityHeaders
    describe XContentTypeOptions do
      describe "#parse" do
        subject(:params) { described_class.new(header).params }

        context "with full header" do
          let(:header) { ["x-content-type-options", "nosniff"] }

          its([:nosniff]) { is_expected.to be_truthy }
        end

        context "without nosniff parameter" do
          let(:header) { ["x-content-type-options", ""] }

          its([:nosniff]) { is_expected.to be_falsey }
        end
      end

      describe "#score" do
        let(:analyzed_header) { described_class.new(header) }

        subject { analyzed_header.score }

        context "with full header" do
          let(:header) { ["x-content-type-options", "nosniff"] }

          it { is_expected.to eq 1 }
        end

        context "without nosniff parameter" do
          let(:header) { ["x-content-type-options", ""] }

          it { is_expected.to eq 0 }
        end

        context "with different parameter value" do
          let(:header) { ["x-content-type-options", "wrong value"] }

          it { is_expected.to eq 0 }
        end
      end
    end
  end
end
