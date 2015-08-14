require "rails_helper"
require "iso_country_codes"

module Headlines
  describe FilteredDomains do
    let!(:domains) { create_list(:domain, 3, :with_scan) }
    let!(:scan) { create :scan, score: 14 }
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
        let(:filter_options) { { ratings: ["A"] } }

        it "returns only domains with given grades" do
          expect(filtered_domains.all.to_ary.count).to eq 1
        end
      end

      context "with issue filter" do
        let(:filter_options) { { issues: ["strict-transport-security"] } }

        it "returns only domains with good issue score" do
          expect(
            filtered_domains.all.map(&:scan_results).select do |scan_result|
              scan_result["strict-transport-security"].to_i < 0
            end
          ).to be_empty
        end
      end
    end
  end
end
