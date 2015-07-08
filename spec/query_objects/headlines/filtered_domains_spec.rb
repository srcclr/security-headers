require "rails_helper"
require "iso_country_codes"

module Headlines
  describe FilteredDomains do
    let!(:domains) { create_list(:domain, 3, :with_scan) }
    let!(:scan) { create :scan, score: 100 }
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
        let(:score_range) { "[70,100]" }

        context "without exclusion range filter" do
          let(:filter_options) { { score_range: score_range } }

          it "returns only domains with score in given range" do
            expect(filtered_domains.all.to_ary.count).to eq 1
          end
        end

        context "with exclusion range filter" do
          let(:filter_options) { { score_range: score_range, exclusion_range: true } }

          it "returns only domains with score not in given range" do
            expect(filtered_domains.all.to_ary.count).to eq 3
          end
        end
      end
    end
  end
end
