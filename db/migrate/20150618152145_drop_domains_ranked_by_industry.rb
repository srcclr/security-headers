class DropDomainsRankedByIndustry < ActiveRecord::Migration
  RANK_SELECT = <<-SQL
    dense_rank() OVER (
      PARTITION BY headlines_domains_categories.category_id
      ORDER BY headlines_domains.rank
    ) AS rank_by_category
  SQL

  def up
    drop_view(:headlines_domain_ranked_by_categories)
  end

  def down
    create_view(:headlines_domain_ranked_by_categories, domain_ranked_by_category.to_sql)
  end

  private

  def domain_ranked_by_category
    Headlines::Domain
      .select("headlines_domains.*, headlines_domains_categories.category_id, #{RANK_SELECT}")
      .joins(:domains_categories)
  end
end
