module Headlines
  module SecurityHeaders
    describe XXssProtection do
      describe "#parse" do
        subject(:parsed_header) { described_class.new(header).parse }

        context "with full header" do
          let(:header) { ["x-xss-protection", "1; mode=block"] }

          it "set parameters" do
            expect(parsed_header.params[:enabled]).to be_truthy
            expect(parsed_header.params[:mode]).to eq "block"
          end
        end

        context "without mode property" do
          let(:header) { ["x-xss-protection", "1"] }

          it "set parameters" do
            expect(parsed_header.params[:enabled]).to be_truthy
            expect(parsed_header.params[:mode]).to be_nil
          end
        end

        context "with disabled header" do
          let(:header) { ["x-xss-protection", "0"] }

          it "set enabled parameter to false" do
            expect(parsed_header.params[:enabled]).to eq false
          end
        end
      end
    end
  end
end
