class AddParentCategoryIdsToDomains < ActiveRecord::Migration
  def change
    add_column :headlines_domains, :parent_category_ids, :integer, array: true, null: false, default: []
  end
end
