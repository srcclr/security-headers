module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      let(:name) { "content-security-policy" }
      let(:response) { double("response") }
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("#{described_class}::SiteSetting", site_setting)
        allow(response).to receive_messages(headers: headers, body: body)
      end

      describe "#score" do
        subject(:score) { described_class.new(name, url, response).score }

        describe "without header and csp in meta" do
          let(:body) { "" }
          let(:value) { nil }

          it { is_expected.to eq(-15) }
        end

        describe "with only header" do
          let(:body) { open_fixture("csp/empty_page.html").read }

          context "with blank value" do
            let(:value) { "" }

            it { is_expected.to eq(-15) }
          end

          context "without valid directives" do
            let(:value) { "invalid-directive 'self';" }

            it { is_expected.to eq(-15) }
          end

          context "with at least one valid directive" do
            let(:value) { "default-src 'self'; invalid-directive 'self';" }

            it { is_expected.to eq(2) }
          end

          context "with invalid directive value" do
            context "with 'none' parameter" do
              let(:value) { "default-src 'self' 'none'; connect-src 'self';" }

              it { is_expected.to eq(-15) }
            end

            context "with '*' parameter" do
              let(:value) { "default-src 'self'; connect-src '*' 'self';" }

              it { is_expected.to eq(-15) }
            end
          end

          context "with default-src equal 'none'" do
            let(:value) { "default-src 'none';" }

            it { is_expected.to eq(2) }
          end

          context "with default-src equal 'self'" do
            let(:value) { "default-src 'self';" }

            it { is_expected.to eq(2) }
          end

          context "with default-src equal '*'" do
            let(:value) { "default-src '*';" }

            it { is_expected.to eq(-4) }
          end

          context "with http: value" do
            let(:value) { "style-src http:;" }

            it { is_expected.to eq(-3) }
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

          context "with script-src equal '*'" do
            let(:value) { "script-src '*';" }

            it { is_expected.to eq(-4) }
          end

          context "with style-src equal '*'" do
            let(:value) { "style-src '*';" }

            it { is_expected.to eq(-4) }
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

          context "with 'unsafe-eval'" do
            context "with 'nonce'" do
              let(:value) { "default-src 'unsafe-eval' 'nonce';" }

              it { is_expected.to eq(-2) }
            end

            context "without 'nonce'" do
              context "with default-src directive" do
                let(:value) { "default-src 'unsafe-eval';" }

                it { is_expected.to eq(-4) }
              end

              context "with script-src directive" do
                let(:value) { "script-src 'unsafe-eval';" }

                it { is_expected.to eq(-4) }
              end

              context "with style-src directive" do
                let(:value) { "style-src 'unsafe-eval';" }

                it { is_expected.to eq(-4) }
              end
            end
          end

          context "with 'unsafe-inline' without 'nonce'" do
            context "with 'nonce'" do
              let(:value) { "default-src 'unsafe-inline' 'nonce';" }

              it { is_expected.to eq(-2) }
            end

            context "without 'nonce'" do
              context "with default-src directive" do
                let(:value) { "default-src 'unsafe-inline';" }

                it { is_expected.to eq(-4) }
              end

              context "with script-src directive" do
                let(:value) { "script-src 'unsafe-inline';" }

                it { is_expected.to eq(-4) }
              end

              context "with style-src directive" do
                let(:value) { "style-src 'unsafe-inline';" }

                it { is_expected.to eq(-4) }
              end
            end
          end

          context "with http protocol" do
            context "with explicit declaration" do
              let(:value) { "default-src 'self'; style-src http://example.com;" }

              it { is_expected.to eq(1) }
            end

            context "with domain without protocol declaration" do
              let(:value) { "default-src 'self'; style-src example.com;" }

              it { is_expected.to eq(1) }
            end

            context "with domain starts with *" do
              context "without any protocol declaration" do
                let(:value) { "default-src 'self'; style-src */example.com" }

                it { is_expected.to eq(1) }
              end

              context "with http protocol declaration" do
                let(:value) { "default-src 'self'; style-src http: */example.com" }

                it { is_expected.to eq(0) }
              end

              context "with https protocol declaration" do
                let(:value) { "default-src 'self'; style-src https: */example.com" }

                it { is_expected.to eq(2) }
              end

              context "with http and https protocol declaration" do
                let(:value) { "default-src 'self'; style-src http: https: */example.com" }

                it { is_expected.to eq(1) }
              end
            end
          end

          context "with potentially unsecure host" do
            context "with whitelist domains" do
              let(:value) { "default-src 'self' https://google.com;" }

              it { is_expected.to eq(-2) }
            end

            context "with subdomains" do
              let(:value) { "default-src '*'; script-src https://subdomain.example.com;" }

              it { is_expected.to eq(-4) }
            end

            context "with unsecure domains" do
              let(:value) { "default-src 'self'; style-src https://unsecurehost.com;" }

              it { is_expected.to eq(2) }
            end
          end
        end

        context "with Report-Only in meta" do
          let(:body) { open_fixture("csp/report-only-in-meta.html").read }

          context "with empty header" do
            let(:value) { "" }

            it { is_expected.to eq(-15) }
          end

          context "with valid header value" do
            let(:value) { "default-src 'self';" }

            it { is_expected.to eq(1) }
          end

          context "with invalid header value" do
            let(:value) { "invalid-directive 'self';" }

            it { is_expected.to eq(-15) }
          end
        end

        context "with csp in meta tags" do
          let(:body) { open_fixture("csp/csp-in-meta.html").read }

          context "with empty header" do
            let(:value) { "" }

            it { is_expected.to eq(0) }
          end

          context "with valid header value" do
            let(:value) { "script-src http:;" }

            it { is_expected.to eq(-1) }
          end

          context "with invalid header value" do
            let(:value) { "invalid-directive 'self';" }

            it { is_expected.to eq(0) }
          end

          context "with Link header" do
            let(:headers) { { "content-security-policy" => value, "link" => "some header value" } }
            let(:value) { "script-src http:;" }

            it { is_expected.to eq(-3) }
          end
        end
      end
    end
  end
end
