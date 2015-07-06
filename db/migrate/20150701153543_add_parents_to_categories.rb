class AddParentsToCategories < ActiveRecord::Migration
  def change
    add_column :headlines_categories, :parents, :integer, array: true, default: [], null: false
    add_index :headlines_categories, :parents
  end
end
