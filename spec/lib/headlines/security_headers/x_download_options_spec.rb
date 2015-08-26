module Headlines
  module SecurityHeaders
    describe XDownloadOptions do
      let(:name) { "x-download-options" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "for header with noopen value" do
          let(:value) { "noopen" }

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
