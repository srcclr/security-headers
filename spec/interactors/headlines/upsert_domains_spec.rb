require "rails_helper"

module Headlines
  describe UpsertDomains do
    let(:domains) { [build_stubbed(:domain, :with_data_alexa, name: "google.com")] }
    let(:progressbar) { double("progressbar") }

    before do
      allow(progressbar).to receive(:increment)
      described_class.call(progressbar: progressbar, domains: domains)
    end

    describe ".call" do
      it "upserts domains" do
        expect(Domain.where(name: "google.com")).to be_exists
      end
    end
  end
end
