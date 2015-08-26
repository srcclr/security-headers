module Headlines
  module SecurityHeaders
    describe XContentTypeOptions do
      let(:name) { "x-content-type-options" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "for header with nosniff value" do
          let(:value) { "nosniff" }

          it { is_expected.to eq 1 }
        end

        context "for header with wrong value" do
          let(:value) { "wrong value" }

          it { is_expected.to eq 0 }
        end
      end
    end
  end
end
