class CreateIndustryRankedDomains < ActiveRecord::Migration
  RANK_SELECT = <<-SQL
    dense_rank() OVER (
      PARTITION BY headlines_categories.industry_id
      ORDER BY headlines_domains.rank
    ) AS industry_rank
  SQL

  def up
    create_view(:headlines_industry_ranked_domains, industry_ranked_domains.to_sql)
  end

  def down
    drop_view(:headlines_industry_ranked_domains)
  end

  private

  def industry_ranked_domains
    Headlines::Domain
      .select("headlines_domains.*, headlines_categories.industry_id, #{RANK_SELECT}")
      .joins(:categories)
  end
end
