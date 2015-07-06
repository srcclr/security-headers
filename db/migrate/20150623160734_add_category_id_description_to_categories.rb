class AddCategoryIdDescriptionToCategories < ActiveRecord::Migration
  def change
    add_column :headlines_categories, :category_id, :integer
    add_column :headlines_categories, :description, :text, default: ''
  end
end
