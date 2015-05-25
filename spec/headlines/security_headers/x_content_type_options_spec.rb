module Headlines
  module SecurityHeaders
    describe XContentTypeOptions do
      describe "#parse" do
        subject(:parsed_header) { described_class.new(header).parse }

        context "with full header" do
          let(:header) { ["x-content-type-options", "nosniff"] }

          it "set parameters" do
            expect(parsed_header.params[:nosniff]).to be_truthy
          end
        end

        context "without nosniff parameter" do
          let(:header) { ["x-content-type-options", ""] }

          it "set parameters" do
            expect(parsed_header.params[:nosniff]).to be_falsey
          end
        end
      end

      describe "#score" do
        let(:parsed_header) { described_class.new(header).parse }

        subject { parsed_header.score }

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
