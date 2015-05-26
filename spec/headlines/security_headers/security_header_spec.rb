module Headlines
  module SecurityHeaders
    describe SecurityHeader do
      describe "#initialize" do
        subject(:params) { described_class.new(header).params }

        context "with header" do
          let(:header) { ["some-security-header", "at least one parameter"] }

          its([:name]) { is_expected.to eq "some-security-header" }
          its([:value]) { is_expected.to eq "at least one parameter" }
        end

        context "without header" do
          let(:header) { ["some-security-header"] }

          its([:name]) { is_expected.to eq "some-security-header" }
          its([:value]) { is_expected.to be_nil }
        end
      end

      describe "#score" do
        let(:header) { ["some-security-header", "at least one parameter"] }

        subject(:score) { described_class.new(header).score }

        it { is_expected.to eq 0 }
      end
    end
  end
end
