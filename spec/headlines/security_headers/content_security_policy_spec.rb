module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      describe "#parse" do
        subject(:params) { described_class.new(header).params }

        context "with full header" do
          let(:header) { ["content-security-policy", "default-src https:; font-src https: data:"] }

          its([:default_src]) { is_expected.to eq "https:" }
          its([:font_src]) { is_expected.to eq "https: data:" }
        end

        context "without any parameters" do
          let(:header) { ["content-security-policy", ""] }

          its([:default_src]) { is_expected.to be_nil }
          its([:font_src]) { is_expected.to be_nil }
        end
      end
    end
  end
end
