require "rails_helper"
require "iso_country_codes"

module Headlines
  describe DomainsInCategory do
    let(:category) { create(:category, :with_parents, :with_domains) }
    let!(:subcategory) { create(:category, :with_parents, :with_domains, category_id: category.id) }

    describe "#all" do
      context "without filter options" do
        subject(:domains) { described_class.new(category: category) }

        it "returns list of all domains for category and all child categories" do
          expect(domains.all.to_ary.count).to eq 4
        end

        it "responds with relationship model" do
          expect(domains.all).to be_kind_of(ActiveRecord::Relation)
        end
      end

      context "with filter options" do
        let(:domain) { create(:domain, country_code: "AU") }

        subject(:domains) { described_class.new(category: category, filter_options: { country: "Australia" }) }

        before { subcategory.domains << domain }

        it "returns only filtered domains" do
          expect(domains.all.to_ary.count).to eq 1
        end
      end
    end
  end
end
