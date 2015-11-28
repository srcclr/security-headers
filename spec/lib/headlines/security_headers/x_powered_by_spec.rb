module Headlines
  module SecurityHeaders
    describe XPoweredBy do
      let(:name) { "x-powered-by" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "with value" do
          let(:value) { "Rails/2.3" }

          it { is_expected.to eq(1) }
        end

        context "without value" do
          let(:value) { "" }

          it { is_expected.to eq(0) }
        end
      end
    end
  end
end
