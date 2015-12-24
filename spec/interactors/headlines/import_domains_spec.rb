require "rails_helper"

module Headlines
  describe ImportDomains do
    describe ".call" do
      let(:rows) { ["1,google.com", "2,facebook.com"] }
      let(:progressbar) { double("progressbar") }

      before do
        allow(progressbar).to receive(:increment)
        described_class.call(rows: rows, progressbar: progressbar)
      end

      it "creates domains" do
        expect(Domain.count).to eq(2)
      end
    end
  end
end
