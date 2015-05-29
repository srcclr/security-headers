class CreateHeadlinesDomainsCategories < ActiveRecord::Migration
  def change
    create_table :headlines_domains_categories do |t|
      t.belongs_to :category
      t.belongs_to :domain

      t.timestamps null: false
    end

    add_index :headlines_domains_categories, :category_id
    add_index :headlines_domains_categories, :domain_id
  end
end
