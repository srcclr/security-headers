class AddIndustyIdToHeadlinesCategories < ActiveRecord::Migration
  def change
    add_column :headlines_categories, :industry_id, :integer
  end
end
