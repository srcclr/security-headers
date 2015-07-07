require "rails_helper"
require "iso_country_codes"

module Headlines
  describe FilteredDomains do
    let!(:domains) { create_list(:domain, 3) }
    let!(:searchable_domain) { create(:domain, country_code: "AU") }

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
    end
  end
end
