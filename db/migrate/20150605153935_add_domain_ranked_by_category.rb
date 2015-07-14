class AddDomainRankedByCategory < ActiveRecord::Migration
  RANK_SELECT = <<-SQL
    dense_rank() OVER (
      PARTITION BY headlines_domains_categories.category_id
      ORDER BY headlines_domains.rank
    ) AS rank_by_category
  SQL

  def up
    create_view(:headlines_domain_ranked_by_categories, domain_ranked_by_category.to_sql)
  end

  def down
    drop_view(:headlines_domain_ranked_by_categories)
  end

  private

  def domain_ranked_by_category
    Headlines::Domain
      .select("headlines_domains.*, headlines_domains_categories.category_id, #{RANK_SELECT}")
      .joins(<<-SQL)
        INNER JOIN headlines_domains_categories
          ON headlines_domains_categories.domain_id = headlines_domains.id
      SQL
  end
end
