require "rails_helper"

module Headlines
  describe UpsertDomains do
    let(:domains) { [build_stubbed(:domain, :with_data_alexa, name: "google.com")] }

    before do
      described_class.call(domains: domains)
    end

    describe ".call" do
      it "upserts domains" do
        expect(Domain.where(name: "google.com")).to be_exists
      end
    end
  end
end
