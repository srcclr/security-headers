module Headlines
  module SecurityHeaders
    describe SecurityHeader do
      describe "#initialize" do
        subject(:params) { described_class.new(value).params }

        context "with header value" do
          let(:value) { "at least one parameter" }

          its([:value]) { is_expected.to eq "at least one parameter" }
        end

        context "without header value" do
          let(:value) { "" }

          its([:value]) { is_expected.to eq "" }
        end
      end
    end
  end
end
