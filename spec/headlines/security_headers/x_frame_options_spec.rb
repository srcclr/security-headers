module Headlines
  module SecurityHeaders
    describe XFrameOptions do
      describe "#parse" do
        subject(:parsed_header) { described_class.new(header).parse }

        context "with full header" do
          let(:header) { ["x-frame-options", "sameorigin"] }

          it "set parameters" do
            expect(parsed_header.params[:sameorigin]).to be_truthy
          end
        end

        context "without any parameters" do
          let(:header) { ["x-frame-options", ""] }

          it "set parameters" do
            expect(parsed_header.params[:sameorigin]).to be_falsey
          end
        end
      end
    end
  end
end
