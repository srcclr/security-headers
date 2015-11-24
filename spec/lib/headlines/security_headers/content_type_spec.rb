module Headlines
  module SecurityHeaders
    describe ContentType do
      let(:name) { "content-type" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "without value" do
          let(:value) { "" }

          it { is_expected.to eq(0) }
        end

        context "with text/html value only" do
          let(:value) { "text/html" }

          it { is_expected.to eq(1) }
        end

        context "with full value" do
          let(:value) { "text/html;charset=utf-8" }

          it { is_expected.to eq(2) }
        end
      end
    end
  end
end
