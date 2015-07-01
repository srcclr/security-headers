require 'rails_helper'

module Headlines
  describe DomainsInCategory do
    let(:category) { create(:category, :with_parents, :with_domains) }
    let!(:subcategory) { create(:category, :with_parents, :with_domains, category_id: category.id) }

    subject(:domains) { described_class.new(category: category) }

    describe "#all" do
      it "returns list of all domains for category and all child categories" do
        expect(domains.all.count).to eq 4
      end

      it "responds with relationship model" do
        expect(domains.all).to be_kind_of(ActiveRecord::Relation)
      end
    end
  end
end
