module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy, "Report-Only header in meta tags" do
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("Headlines::SecurityHeaders::CspDirective::SiteSetting", site_setting)
      end

      describe "#score" do
        let(:body) { open_fixture("csp/report-only-in-meta.html").read }

        subject(:score) { described_class.new(headers, body, url).score }

        context "with empty header" do
          let(:value) { "" }

          it { is_expected.to eq(-15) }
        end

        context "with valid header value" do
          let(:value) { "default-src 'self';" }

          it { is_expected.to eq(3) }
        end

        context "with invalid header value" do
          let(:value) { "invalid-directive 'self';" }

          it { is_expected.to eq(-15) }
        end
      end
    end
  end
end
