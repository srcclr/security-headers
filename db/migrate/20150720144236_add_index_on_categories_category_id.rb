class AddIndexOnCategoriesCategoryId < ActiveRecord::Migration
  def up
    add_index :headlines_categories, :category_id
  end

  def down
    remove_index :headlines_categories, :category_id
  end
end
