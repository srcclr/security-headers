module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("Headlines::SecurityHeaders::CspDirective::SiteSetting", site_setting)
      end

      describe "#score" do
        let(:body) { open_fixture("csp/empty_page.html").read }

        subject(:score) { described_class.new(headers, body, url).score }

        context "without header and csp in meta" do
          let(:body) { "" }
          let(:value) { nil }

          it { is_expected.to eq(-15) }
        end

        context "with blank value" do
          let(:value) { "" }

          it { is_expected.to eq(-15) }
        end

        context "without valid directives" do
          let(:value) { "invalid-directive 'self';" }

          it { is_expected.to eq(-15) }
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
      end
    end
  end
end
