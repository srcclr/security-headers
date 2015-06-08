require "rails_helper"

module Headlines
  describe "Fetch categories with top domains" do
    let(:params) { {} }

    before do
      CategoriesController::TOP_CATEGORIES.each do |category|
        create(:category, :with_domains, title: category)
      end
    end

    subject(:get_categories) { get("/headlines/categories.json", params) && response }

    it "responds with categories" do
      expect(get_categories).to be_success
    end

    context "when domains_per_category param has been sent" do
      let(:params) { { domains_per_category: 1 } }

      subject(:categories) { JSON.parse(get_categories.body)["categories"] }

      it "responds with limited number of domains per category" do
        categories.each do |category|
          expect(category["domains_ranked"].size).to be 1
        end
      end
    end
  end
end
