module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy, "non restrictive rules" do
      let(:headers) { { "content-security-policy" => value } }
      let(:url) { "example.com" }
      let(:site_setting) { OpenStruct.new(whitelisted_domains: "facebook.com|google.com") }

      before do
        stub_const("Headlines::SecurityHeaders::CspDirective::SiteSetting", site_setting)
      end

      describe "#score" do
        let(:body) { open_fixture("csp/empty_page.html").read }

        subject(:score) { described_class.new(headers, body, url).score }

        context "with default-src equal '*'" do
          let(:value) { "default-src '*';" }

          it { is_expected.to eq(-4) }
        end

        context "with script-src equal '*'" do
          let(:value) { "script-src '*';" }

          it { is_expected.to eq(-4) }
        end

        context "with style-src equal '*'" do
          let(:value) { "style-src '*';" }

          it { is_expected.to eq(-4) }
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

        context "with 'unsafe-inline'" do
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
      end
    end
  end
end
