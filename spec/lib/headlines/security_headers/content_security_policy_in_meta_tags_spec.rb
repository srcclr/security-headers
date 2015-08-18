module Headlines
  module SecurityHeaders
    describe ContentSecurityPolicy do
      let(:name) { "content-security-policy" }

      describe "#score" do
        subject(:score) { described_class.new(name, value, body).score }

        describe "with meta tags" do
          let(:value) { "" }

          context "with Report-Only in meta" do
            let(:body) { open_fixture("report-only-in-meta.html").read }

            it { is_expected.to eq(-1) }
          end
        end
      end
    end
  end
end
