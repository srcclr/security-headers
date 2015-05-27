module Headlines
  module SecurityHeaders
    describe XContentTypeOptions do
      describe "#parse" do
        subject(:params) { described_class.new(value).params }

        context "header with nosniff value" do
          let(:value) { "nosniff" }

          its([:enabled]) { is_expected.to be_truthy }
        end

        context "header with wrong value" do
          let(:value) { "wrong value" }

          its([:enabled]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
