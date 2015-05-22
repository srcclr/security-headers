require "rails_helper"

module Headlines
  describe ImportDomains do
    let(:file) { double("file") }
    let(:domains) { ["1,google.com", "2,www.facebook.com"] }

    before do
      allow(file).to receive(:fetch_in_batches).and_yield(domains)
      described_class.call(file: file)
    end

    describe ".call" do
      it "creates domains from file" do
        expect(Domain.where(name: "google.com")).to be_exists
      end
    end
  end
end
