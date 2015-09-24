module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy, "http protocol rules" do
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("Headlines::SecurityHeaders::CspDirective::SiteSetting", site_setting)
      end

      describe "#score" do
        let(:body) { open_fixture("csp/empty_page.html").read }

        subject(:score) { described_class.new(headers, body, url).score }

        context "with http: source" do
          let(:value) { "style-src http:;" }

          it { is_expected.to eq(-1) }
        end

        context "with explicit declaration" do
          let(:value) { "default-src 'self'; style-src http://example.com;" }

          it { is_expected.to eq(3) }
        end

        context "with domain without protocol declaration" do
          let(:value) { "default-src 'self'; style-src example.com;" }

          it { is_expected.to eq(3) }
        end

        context "with domain starts with *" do
          context "without any protocol declaration" do
            let(:value) { "default-src 'self'; style-src */example.com" }

            it { is_expected.to eq(3) }
          end

          context "with http protocol declaration" do
            let(:value) { "default-src 'self'; style-src http: */example.com" }

            it { is_expected.to eq(3) }
          end

          context "with https protocol declaration" do
            let(:value) { "default-src 'self'; style-src https: */example.com" }

            it { is_expected.to eq(4) }
          end

          context "with http and https protocol declaration" do
            let(:value) { "default-src 'self'; style-src http: https: */example.com" }

            it { is_expected.to eq(3) }
          end
        end

        context "with potentially unsecure host" do
          context "with whitelist domains" do
            let(:value) { "default-src 'self' https://google.com;" }

            it { is_expected.to eq(0) }
          end

          context "with subdomains" do
            let(:value) { "default-src '*'; script-src https://subdomain.example.com;" }

            it { is_expected.to eq(-2) }
          end

          context "with unsecure domains" do
            let(:value) { "default-src 'self'; style-src https://unsecurehost.com;" }

            it { is_expected.to eq(4) }
          end
        end
      end
    end
  end
end
