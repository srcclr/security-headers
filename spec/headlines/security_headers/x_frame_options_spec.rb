module Headlines
  module SecurityHeaders
    describe XFrameOptions do
      describe "#parse" do
        subject(:params) { described_class.new(header).params }

        context "with full header" do
          let(:header) { ["x-frame-options", "sameorigin"] }

          its([:sameorigin]) { is_expected.to be_truthy }
        end

        context "without any parameters" do
          let(:header) { ["x-frame-options", ""] }

          its([:sameorigin]) { is_expected.to be_falsey }
        end
      end
    end
  end
end
