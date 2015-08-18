module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      let(:name) { "content-security-policy" }

      describe "#score" do
        subject(:score) { described_class.new(name, value, body).score }

        describe "without meta tags" do
          let(:body) { "<html><head></head><body></body></html>" }

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

            it { is_expected.to eq(4) }
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

            it { is_expected.to eq(4) }
          end

          context "with default-src equal 'self'" do
            let(:value) { "default-src 'self';" }

            it { is_expected.to eq(4) }
          end

          context "with default-src equal '*'" do
            let(:value) { "default-src '*';" }

            it { is_expected.to eq(-2) }
          end

          context "with http: value" do
            let(:value) { "style-src http:;" }

            it { is_expected.to eq(-1) }
          end

          context "with script-src equal '*'" do
            let(:value) { "script-src '*';" }

            it { is_expected.to eq(-2) }
          end

          context "with style-src equal '*'" do
            let(:value) { "style-src '*';" }

            it { is_expected.to eq(-2) }
          end

          context "with script-src equal 'self'" do
            let(:value) { "script-src 'self';" }

            it { is_expected.to eq(1) }
          end

          context "with style-src equal 'self'" do
            let(:value) { "style-src 'self';" }

            it { is_expected.to eq(1) }
          end

          context "with script-src equal 'nonce-<some value>'" do
            let(:value) { "script-src 'nonce-Nc3n83cnSAd3wc3Sasdfn939hc3';" }

            it { is_expected.to eq(2) }
          end

          context "with style-src equal 'nonce-<some value>'" do
            let(:value) { "style-src 'nonce-Nc3n83cnSAd3wc3Sasdfn939hc3';" }

            it { is_expected.to eq(2) }
          end

          context "with 'unsafe-eval'" do
            context "with 'nonce'" do
              let(:value) { "default-src 'unsafe-eval' 'nonce';" }

              it { is_expected.to eq(0) }
            end

            context "without 'nonce'" do
              context "with default-src directive" do
                let(:value) { "default-src 'unsafe-eval';" }

                it { is_expected.to eq(-2) }
              end

              context "with script-src directive" do
                let(:value) { "script-src 'unsafe-eval';" }

                it { is_expected.to eq(-2) }
              end

              context "with style-src directive" do
                let(:value) { "style-src 'unsafe-eval';" }

                it { is_expected.to eq(-2) }
              end
            end
          end

          context "with 'unsafe-inline' without 'nonce'" do
            context "with 'nonce'" do
              let(:value) { "default-src 'unsafe-inline' 'nonce';" }

              it { is_expected.to eq(0) }
            end

            context "without 'nonce'" do
              context "with default-src directive" do
                let(:value) { "default-src 'unsafe-inline';" }

                it { is_expected.to eq(-2) }
              end

              context "with script-src directive" do
                let(:value) { "script-src 'unsafe-inline';" }

                it { is_expected.to eq(-2) }
              end

              context "with style-src directive" do
                let(:value) { "style-src 'unsafe-inline';" }

                it { is_expected.to eq(-2) }
              end
            end
          end
        end
      end
    end
  end
end
