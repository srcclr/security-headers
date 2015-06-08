require "rails_helper"

module Headlines
  describe UpsertDomainsCategories do
    let(:domain) { create(:domain, :with_data_alexa) }

    describe ".call" do
      subject(:upsert_domains_categories) { described_class.call(domains: [domain]) }

      it "inserts domains categories" do
        expect { upsert_domains_categories }.to change { DomainsCategory.count }.by(2)
      end

      context "when domains category with the same domain_id and category_id presents" do
        before do
          create(
            :domains_category,
            category_id: "498976",
            domain_id: domain.id
          )
        end

        it "skips inserting domains categories for duplicated ones" do
          expect { upsert_domains_categories }.to change { DomainsCategory.count }.by(1)
        end
      end
    end
  end
end
