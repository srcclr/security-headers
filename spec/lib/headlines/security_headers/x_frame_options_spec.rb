module Headlines
  module SecurityHeaders
    describe XFrameOptions do
      describe "#parse" do
        let(:name) { "x-frame-options" }

        subject(:params) { described_class.new(name, value).params }

        context "header with DENY value" do
          let(:value) { "DENY" }

          its([:enabled]) { is_expected.to be_truthy }
          its([:deny]) { is_expected.to be_truthy }
        end

        context "header with SAMEORIGIN value" do
          let(:value) { "SAMEORIGIN" }

          its([:enabled]) { is_expected.to be_truthy }
          its([:sameorigin]) { is_expected.to be_truthy }
        end

        context "header with ALLOW-FROM value" do
          context "for http URI" do
            let(:value) { "ALLOW-FROM http://example.com" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:allow_from]) { is_expected.to eq "http://example.com" }
          end

          context "for https URI" do
            let(:value) { "ALLOW-FROM https://example.com" }

            its([:enabled]) { is_expected.to be_truthy }
            its([:allow_from]) { is_expected.to eq "https://example.com" }
          end

          context "for not URI value" do
            let(:value) { "ALLOW-FROM example.com" }

            its([:enabled]) { is_expected.to be_falsey }
          end
        end

        context "header with wrong value" do
          let(:value) { "WRONGVALUE" }

          its([:enabled]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
