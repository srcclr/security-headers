module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      describe "#parse" do
        subject(:params) { described_class.new(value).params }

        context "header with some parameters" do
          let(:value) { "default-src https:; font-src https: data:" }

          its([:enabled]) { is_expected.to be_truthy }
          its([:default_src]) { is_expected.to eq "https:" }
          its([:font_src]) { is_expected.to eq "https: data:" }
        end

        context "header with empty parameters" do
          let(:value) { "" }

          its([:enabled]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
