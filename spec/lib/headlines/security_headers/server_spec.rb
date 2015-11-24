module Headlines
  module SecurityHeaders
    describe Server do
      let(:name) { "server" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "with value" do
          let(:value) { "nginx" }

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
