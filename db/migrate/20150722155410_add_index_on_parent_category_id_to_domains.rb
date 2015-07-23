class AddIndexOnParentCategoryIdToDomains < ActiveRecord::Migration
  def change
    remove_index :headlines_categories, :parents
    add_index :headlines_categories, :parents, using: :gin
    add_index :headlines_domains, :parent_category_ids, using: :gin
  end

  def down
    add_index :headlines_categories, :parents
    remove_index :headlines_categories, :parents, using: :gin
    remove_index :headlines_domains, :parent_category_ids, using: :gin
  end
end
