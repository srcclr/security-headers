module Headlines
  module SecurityHeaders
    describe PublicKeyPins do
      let(:name) { "public-key-pins" }
      let(:pin_key) { "pin-sha256='E9CZ9INDbd+2eRQozYqqbQ2yXLVKB9+xcprMF+44U1g=';" }
      let(:max_age) { "max-age=2592000;" }
      let(:report_uri) { "report-uri=http://example.com;" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "when header is missing" do
          let(:value) { "" }

          it { is_expected.to eq 0 }
        end

        context "when header hasn't pin-sha256 option" do
          let(:value) { "#{max_age}" }

          it { is_expected.to eq 0 }
        end

        context "when header has wrong pin-sha256 option" do
          let(:value) { "pin-sha256=wrong-value;#{max_age}" }

          it { is_expected.to eq 0 }
        end

        context "when header hasn't max-age option" do
          let(:value) { "#{pin_key}#{report_uri}includeSubDomains;" }

          it { is_expected.to eq 0 }
        end

        context "when header has report-only option" do
          let(:value) { "#{pin_key}#{max_age}#{report_uri}report-only" }

          it { is_expected.to eq 1 }
        end

        context "when header has only max-age option" do
          let(:value) { "#{pin_key}#{max_age}" }

          it { is_expected.to eq 1 }
        end

        context "when header has max-age and includeSubDomains option" do
          let(:value) { "#{pin_key}#{max_age}includeSubDomains" }

          it { is_expected.to eq 2 }
        end

        context "when header has max-age and report-uri options" do
          let(:value) { "#{pin_key}#{max_age}#{report_uri}" }

          it { is_expected.to eq 2 }
        end

        context "when header has all options" do
          let(:value) { "#{pin_key}#{max_age}#{report_uri}includeSubDomains;" }

          it { is_expected.to eq 3 }
        end

        context "when header has report-uri option" do
          context "with invalid url" do
            let(:value) { "#{pin_key}#{max_age}report-uri=invalid_domain" }

            it { is_expected.to eq 1 }
          end

          context "with valid url" do
            let(:value) { "#{pin_key}#{max_age}#{report_uri}" }

            it { is_expected.to eq 2 }
          end
        end
      end
    end
  end
end
