class RenameDomainIdToDomainNameOnDomainsCategories < ActiveRecord::Migration
  RANK_SELECT = <<-SQL
    dense_rank() OVER (
      PARTITION BY headlines_categories.industry_id
      ORDER BY headlines_domains.rank
    ) AS industry_rank
  SQL

  def up
    drop_view :headlines_industry_ranked_domains
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
    create_view(:headlines_industry_ranked_domains, industry_ranked_domains.to_sql)
  end

  private

  def industry_ranked_domains
    Headlines::Domain
      .select("headlines_domains.*, headlines_categories.industry_id, #{RANK_SELECT}")
      .joins(:categories)
  end
end
