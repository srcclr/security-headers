require "rails_helper"
require "iso_country_codes"

module Headlines
  describe FilteredDomains do
    let!(:domains) { create_list(:domain, 3, :with_scan) }
    let!(:scan) { create :scan, score: 3 }
    let!(:searchable_domain) { create(:domain, country_code: "AU", scans: [scan]) }

    subject(:filtered_domains) { described_class.new(domains: Domain.all, filter_options: filter_options) }

    describe "#call" do
      context "without any filter" do
        let(:filter_options) { Hash.new }

        it "returns all domains" do
          expect(filtered_domains.all.to_ary.count).to eq 4
        end
      end

      context "with country filter" do
        let(:filter_options) { { country: "Australia" } }

        it "returns only filtered domains" do
          expect(filtered_domains.all.to_ary.count).to eq 1
        end
      end

      context "with rating filter" do
        let(:filter_options) { { ratings: ["3"] } }

        it "returns only domains with given grades" do
          expect(filtered_domains.all.to_ary.count).to eq 1
        end
      end

      context "with header filter" do
        let(:filter_options) { { headers: ["strict-transport-security"] } }

        it "returns only domains with good header score" do
          expect(filtered_domains.all.to_ary.count).to eq 0
        end
      end
    end
  end
end
