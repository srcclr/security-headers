require "rails_helper"

module Headlines
  describe DomainsInCategory do
    let(:category) { create(:category) }
    let!(:subcategory) { create(:category, category_id: category.id) }

    let(:domains) { create_list(:domain, 2, parent_category_ids: [category.id, subcategory.id]) }

    subject(:domains_in_category) { described_class.new(category: category) }

    describe "#all" do
      it "returns list of all domains for category and all child categories" do
        expect(domains_in_category.all).to eq domains
      end

      it "responds with relationship model" do
        expect(domains_in_category.all).to be_kind_of(ActiveRecord::Relation)
      end
    end
  end
end
