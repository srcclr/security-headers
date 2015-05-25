module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      describe "#parse" do
        subject(:parsed_header) { described_class.new(header).parse }

        context "with full header" do
          let(:header) { ["content-security-policy", "default-src https:; font-src https: data:"] }

          it "set parameters" do
            expect(parsed_header.params[:default_src]).to eq "https:"
            expect(parsed_header.params[:font_src]).to eq "https: data:"
          end
        end

        context "without any parameters" do
          let(:header) { ["content-security-policy", ""] }

          it "set parameters" do
            expect(parsed_header.params[:default_src]).to be_nil
            expect(parsed_header.params[:font_src]).to be_nil
          end
        end
      end
    end
  end
end
