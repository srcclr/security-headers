class AddDefaultValueToCategoriesCreatedAtUpdatedAt < ActiveRecord::Migration
  def up
    change_column :headlines_categories, :created_at, :datetime, default: 'NOW()'
    change_column :headlines_categories, :updated_at, :datetime, default: 'NOW()'
    change_column :headlines_domains_categories, :created_at, :datetime, default: 'NOW()'
    change_column :headlines_domains_categories, :updated_at, :datetime, default: 'NOW()'
  end

  def down
    change_column :headlines_categories, :created_at, :datetime, default: nil
    change_column :headlines_categories, :updated_at, :datetime, default: nil
    change_column :headlines_domains_categories, :created_at, :datetime, default: nil
    change_column :headlines_domains_categories, :updated_at, :datetime, default: nil
  end
end
