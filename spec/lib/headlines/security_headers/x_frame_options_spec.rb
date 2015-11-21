module Headlines
  module SecurityHeaders
    describe XFrameOptions do
      describe "#score" do
        let(:name) { "x-frame-options" }
        let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

        before do
          stub_const("#{described_class}::SiteSetting", site_setting)
        end

        subject(:score) { described_class.new(name, value).score }

        context "when value is DENY" do
          let(:value) { "DENY" }

          it { is_expected.to eq(3) }
        end

        context "when value is SAMEORIGIN" do
          let(:value) { "SAMEORIGIN" }

          it { is_expected.to eq(2) }
        end

        context "when value is sameorigin" do
          let(:value) { "sameorigin" }

          it { is_expected.to eq(2) }
        end

        context "when value is ALLOW-FROM whitelisted domain" do
          let(:value) { "ALLOW-FROM https://facebook.com" }

          it { is_expected.to eq(1) }
        end

        context "when value is ALLOW-FROM any domain" do
          let(:value) { "ALLOW-FROM http://example.com" }

          it { is_expected.to eq(-1) }
        end

        context "when values is blank" do
          let(:value) { "" }

          it { is_expected.to eq(-1) }
        end
      end
    end
  end
end
