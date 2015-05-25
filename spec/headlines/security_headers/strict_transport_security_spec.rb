module Headlines
  module SecurityHeaders
    describe StrictTransportSecurity do
      describe "#parse" do
        subject(:parsed_header) { described_class.new(header).parse }

        context "with full header" do
          let(:header) { ["strict-transport-security", "max-age=631138519; includeSubDomains"] }

          it "set parameters" do
            expect(parsed_header.params[:max_age]).to eq "631138519"
            expect(parsed_header.params[:includeSubDomains]).to be_truthy
          end
        end

        context "without includeSubDomains parameter" do
          let(:header) { ["strict-transport-security", "max-age=631138519"] }

          it "set parameters" do
            expect(parsed_header.params[:max_age]).to eq "631138519"
            expect(parsed_header.params[:includeSubDomains]).to be_falsey
          end
        end

        context "without any parameter" do
          let(:header) { ["strict-transport-security", ""] }

          it "set parameters" do
            expect(parsed_header.params[:max_age]).to be_nil
            expect(parsed_header.params[:includeSubDomains]).to be_falsey
          end
        end
      end
    end
  end
end
