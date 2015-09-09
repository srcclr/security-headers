module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy, "restrictive rules" do
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("Headlines::SecurityHeaders::CspDirective::SiteSetting", site_setting)
      end

      describe "#score" do
        let(:body) { open_fixture("csp/empty_page.html").read }

        subject(:score) { described_class.new(headers, body, url).score }

        context "with at least one valid directive" do
          let(:value) { "default-src 'self'; invalid-directive 'self';" }

          it { is_expected.to eq(2) }
        end

        context "with default-src equal 'none'" do
          let(:value) { "default-src 'none';" }

          it { is_expected.to eq(2) }
        end

        context "with default-src equal 'self'" do
          let(:value) { "default-src 'self';" }

          it { is_expected.to eq(2) }
        end

        context "with report-uri directive" do
          let(:value) { "default-src 'self'; report-uri https://example.com" }

          it { is_expected.to eq(6) }
        end

        context "with Content-Security-Policy-Report-Only header" do
          let(:value) { "default-src 'self';" }

          context "with identical" do
            let(:headers) do
              {
                "content-security-policy" => value,
                "content-security-policy-report-only" => value
              }
            end

            it { is_expected.to eq(6) }
          end

          context "with different" do
            let(:headers) do
              {
                "content-security-policy" => value,
                "content-security-policy-report-only" => "different-directive 'self';"
              }
            end

            context "without report-uri directive" do
              it { is_expected.to eq(2) }
            end

            context "with report-uri directive" do
              let(:value) { "default-src 'self'; report-uri https://example.com" }

              it { is_expected.to eq(6) }
            end
          end
        end

        context "with script-src equal 'self'" do
          let(:value) { "script-src 'self';" }

          it { is_expected.to eq(-1) }
        end

        context "with style-src equal 'self'" do
          let(:value) { "style-src 'self';" }

          it { is_expected.to eq(-1) }
        end

        context "with script-src equal 'nonce-<some value>'" do
          let(:value) { "script-src 'nonce-Nc3n83cnSAd3wc3Sasdfn939hc3';" }

          it { is_expected.to eq(0) }
        end

        context "with style-src equal 'nonce-<some value>'" do
          let(:value) { "style-src 'nonce-Nc3n83cnSAd3wc3Sasdfn939hc3';" }

          it { is_expected.to eq(0) }
        end
      end
    end
  end
end
