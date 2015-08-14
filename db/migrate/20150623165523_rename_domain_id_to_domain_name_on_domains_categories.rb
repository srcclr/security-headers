class RenameDomainIdToDomainNameOnDomainsCategories < ActiveRecord::Migration
  def up
    remove_index :headlines_domains_categories, :domain_id
    remove_column :headlines_domains_categories, :domain_id

    add_column :headlines_domains_categories, :domain_name, :string
    add_index :headlines_domains_categories, :domain_name
  end

  def down
    remove_index :headlines_domains_categories, :domain_name
    remove_column :headlines_domains_categories, :domain_name

    add_column :headlines_domains_categories, :domain_id, :integer
    add_index :headlines_domains_categories, :domain_id
  end
end
