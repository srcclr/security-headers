require "rails_helper"

module Headlines
  describe UpsertCategories do
    let(:domains) { [build_stubbed(:domain, :with_data_alexa)] }

    describe ".call" do
      subject(:upsert_categories) { described_class.call(domains: domains) }

      it "inserts categories" do
        expect { upsert_categories }.to change { Category.count }.by(2)
      end

      context "when category with the same id presents" do
        before { create(:category, id: "498976") }

        it "skips inserting categories for duplicated ones" do
          expect { upsert_categories }.to change { Category.count }.by(1)
        end
      end
    end
  end
end
